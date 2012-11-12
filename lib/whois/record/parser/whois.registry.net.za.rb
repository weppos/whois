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

        property_supported :disclaimer do
          node("field:disclaimer")
        end

        property_supported :domain do
          node("field:domain_name")
        end

        property_not_supported :domain_id

        property_not_supported :referral_whois

        property_not_supported :referral_url

        property_supported :status do
          node("field:status")
        end

        property_supported :available? do
          node("status:available") ? true : false
        end

        property_supported :registered? do
          !available?
        end

        property_supported :created_on do
          node("field:dates") do
            node("field:dates") =~ /Registration Date:\s*(\d{4}-\d{2}-\d{2})/
            parse_date($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          node("field:dates") do
            node("field:dates") =~ /Renewal Date:\s*(\d{4}-\d{2}-\d{2})/
            parse_date($1)
          end
        end

        property_supported :registrar do
          node("field:registrar") do
            node("field:registrar") =~ /(.+) \[ ID = (.+) \]/
            Whois::Record::Registrar.new(:name => $1.strip, :id => $2.strip)
          end
        end

        # The response for this property gets wrapped in an array by Whois::Record::Parser::Base#handle_property
        property_supported :registrant_contacts do
          node("field:registrant_details") do
            build_registrant_contacts
          end
        end

        property_not_supported :admin_contacts

        property_not_supported :technical_contacts

        property_supported :nameservers do
          node("field:nameservers") do
            nameservers = node("field:nameservers").gsub(/\n\s+/, ",").split(",")
            Array.wrap(nameservers).map do |nameserver|
              Record::Nameserver.new(:name => nameserver)
            end
          end
        end

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
          registrant_lines = node("field:registrant_details").split("\n")
          details = { :name => registrant_lines.shift }
          [:email, :phone, :fax].each do |contact_method|
            details[contact_method] = registrant_lines.shift.split(":").last.strip
          end
          details
        end

        def registrant_address_details
          { :address => node("field:registrant_address").gsub(/\n\s+/, " ") }
        end

        def parse_date(date_string)
          Time.parse(date_string) if date_string
        end

      end
    end
  end
end
