require 'whois/record/parser/base'
require 'whois/record/scanners/whois.registry.net.za'


module Whois
  class Record
    class Parser
      #--
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      # ++
      class WhoisRegistryNetZa < Base
        include Scanners::Nodable

        property_supported :available? do
          node(:available)
        end

        property_supported :registered? do
          !available?
        end

        property_supported :domain do
          node(:domain_name)
        end

        property_supported :created_on do
          parse_date(node(:registration_date))
        end

        property_supported :expires_on do
          parse_date(node(:renewal_date))
        end

        property_supported :nameservers do
          if registered?
            node(:nameservers).map { |nameserver| Record::Nameserver.new(:name => nameserver) }
          else
            []
          end
        end

        property_supported :registrar do
          if node(:registrar_id)
            Whois::Record::Registrar.new(:name => node(:registrar_name), :id => node(:registrar_id))
          else
            nil
          end
        end

        # The response for this property gets wrapped in an array by Whois::Record::Parser::Base#handle_property
        property_supported :registrant_contacts do
          if registered?
            build_registrant_contacts
          else
            []
          end
        end

        property_supported :status do
          node(:status)
        end

        property_supported :disclaimer do
          node(:disclaimer)
        end

        property_not_supported :domain_id
        property_not_supported :referral_whois
        property_not_supported :referral_url
        property_not_supported :updated_on
        property_not_supported :admin_contacts
        property_not_supported :technical_contacts

        def parse
          Scanners::WhoisRegistryNetZa.new(content_for_scanner).parse
        end

        private

        def build_registrant_contacts
          Whois::Record::Contact.new(
            {:type => Whois::Record::Contact::TYPE_REGISTRANT}.merge(registrant_details).merge(registrant_address_details)
          )
        end

        def registrant_details
          if node(:registrant_name)
            { :name => node(:registrant_name), :email => node(:registrant_email), :phone => node(:registrant_telephone), :fax => node(:registrant_fax)}
          end
        end

        def registrant_address_details
          { :address => node(:registrant_address) }
        end

        def parse_date(date_string)
          if date_string
            date_parts = date_string.split("-")
            Time.new(*date_parts,nil,nil,nil,"+02:00")
          else
            nil
          end
        end

        property_supported :registered? do
          !available?
        end

        property_supported :nameservers do
          if content_for_scanner =~ /Name Servers:\n((.+\n)+)\n/
            $1.split("\n").map do |line|
              Record::Nameserver.new(:name => line.strip)
            end
          end
        end

        property_supported :registrar do
          if content_for_scanner =~ /Registrar:\n(.+)\[ ID = (.+) \]\s*\n/
            Whois::Record::Registrar.new(:name => $1.strip, :id => $2.strip)
          end
        end

        property_supported :registrant_contacts do
          if content_for_scanner =~ /Registrant:\n((.+\n)+)\n/
            reg_details = $1.split("\n")
            name = reg_details[0].strip
            email = get_email(reg_details[1])
            telephone = get_telephone(reg_details[2])
            fax = get_fax(reg_details[3])
          end

          if content_for_scanner =~ /Registrant's Address:\n((.+\n)+)\n/
            address = ($1.split("\n").map { |part| part.strip }).join(" ")
          end

          [Whois::Record::Contact.new(:type => Whois::Record::Contact::TYPE_REGISTRANT, :name => name, :email => email, :phone => telephone, :fax => fax, :address => address)]
        end

        private

        def get_email(email_candidate)
          $1.strip if email_candidate.strip =~ /^Email: (.+)$/
        end

        def get_telephone(telephone_candidate)
          $1.strip if telephone_candidate.strip =~ /^Tel: (.+)$/
        end

        def get_fax(fax_candidate)
          $1.strip if fax_candidate.strip =~ /^Fax: (.+)$/
        end
      end
    end
  end
end
