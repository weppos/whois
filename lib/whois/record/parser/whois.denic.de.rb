#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/parser/scanners/whois.denic.de.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.denic.de server.
      #
      # @author Simone Carletti <weppos@weppos.net>
      # @author Aaron Mueller <mail@aaron-mueller.de>
      #
      class WhoisDenicDe < Base
        include Scanners::Ast

        property_supported :disclaimer do
          node("Disclaimer")
        end


        property_supported :domain do
          node("Domain")
        end

        property_not_supported :domain_id


        property_supported :status do
          if node("Status")
            case node("Status")
              when "connect"    then :registered
              when "free"       then :available
              when "invalid"    then :invalid
              # NEWSTATUS (inactive)
              # The domain is registered, but there is not DNS entry for it.
              when "failed"     then :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{node("Status")}'.")
            end
          else
            if version < "2.0"
              if invalid?
                :invalid
              else
                :available
              end
            else
              Whois.bug!(ParserError, "Unable to parse status.")
            end
          end
        end

        property_supported :available? do
          !invalid? && (!!node("status:available") || node("Status") == "free")
        end

        property_supported :registered? do
          !invalid? && !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          node("Changed") { |raw| Time.parse(raw) }
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
          build_contact("Admin-C", Whois::Record::Contact::TYPE_ADMIN)
        end

        # FIXME: check against different schema

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
              Record::Nameserver.new(name.chomp("."), ipv4)
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
            !!node("status:invalid") || node("Status") == "invalid"
          end
        end


        # Initializes a new {Scanners::WhoisDenicDe} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisDenicDe.new(content_for_scanner).parse
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
