require 'whois/record/parser/base'
require 'whois/record/scanners/whois.registry.net.za'


module Whois
  class Record
    class Parser
      # Parser for the whois.registry.za.net server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
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
          node(:registrar_id) do
            Whois::Record::Registrar.new(:name => node(:registrar_name), :id => node(:registrar_id))
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

      end
    end
  end
end
