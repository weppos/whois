#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.denic.de.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.denic.de server.
      #
      # @author Simone Carletti <weppos@weppos.net>
      # @author Aaron Mueller <mail@aaron-mueller.de>
      #
      class WhoisDenicDe < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisDenicDe


        property_supported :disclaimer do
          node("Disclaimer")
        end


        property_supported :domain do
          node("Domain")
        end

        property_not_supported :domain_id


        property_supported :status do
          case node("Status")
          when "connect"
            :registered
          when "free"
            :available
          when "invalid"
            :invalid
          # NEWSTATUS (inactive)
          # The domain is registered, but there is not DNS entry for it.
          when "failed"
            :registered
          else
            if response_error?
              :invalid
            else
              Whois.bug!(ParserError, "Unknown status `#{node("Status")}'.")
            end
          end
        end

        property_supported :available? do
          !invalid? && node("Status") == "free"
        end

        property_supported :registered? do
          !invalid? && !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          node("Changed") { |value| Time.parse(value) }
        end

        property_not_supported :expires_on


        property_supported :registrar do
          node("Zone-C") do |raw|
            Record::Registrar.new(
                :id => nil,
                :name => raw["name"],
                :organization => raw["organization"],
                :url => nil
            )
          end
        end

        property_supported :registrant_contacts do
          build_contact("Holder", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Admin-C", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Tech-C", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        # Nameservers are listed in the following formats:
        #
        #   Nserver:     ns1.prodns.de. 213.160.64.75
        #   Nserver:     ns1.prodns.de.
        #
        property_supported :nameservers do
          node("Nserver") do |values|
            values.map do |line|
              name, ipv4 = line.split(/\s+/)
              Record::Nameserver.new(name: name, ipv4: ipv4)
            end
          end
        end


        # Checks whether the response has been throttled.
        #
        # @return [Boolean]
        #
        # @example
        #   % Error: 55000000002 Connection refused; access control limit reached.
        #
        def response_throttled?
          !!node("response:throttled")
        end

        def response_error?
          !!node("response:error")
        end


        # NEWPROPERTY
        def version
          cached_properties_fetch :version do
            if content_for_scanner =~ /^% Version: (.+)$/
              $1
            end
          end
        end

        # NEWPROPERTY
        def invalid?
          cached_properties_fetch :invalid? do
            node("Status") == "invalid" ||
            response_error?
          end
        end


        private

        def build_contact(element, type)
          node(element) do |raw|
            Record::Contact.new(raw) do |c|
              c.type = type
            end
          end
        end

      end
    end
  end
end
