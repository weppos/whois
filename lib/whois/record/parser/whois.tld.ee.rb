#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_whoisd'
require 'whois/record/scanners/whois.tld.ee.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.tld.ee server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      # 
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisTldEe < BaseWhoisd
        include Scanners::Ast

        property_supported :admin_contacts do
          if content_for_scanner =~ /admin-c:\s+(.+)\n/
            build_contact($1, Whois::Record::Contact::TYPE_ADMIN)
          end
        end

        property_supported :registrant_contacts do
          if content_for_scanner =~ /registrant:\s+(.+)\n/
            build_contact($1, Whois::Record::Contact::TYPE_REGISTRANT)
          end
        end

        property_not_supported :technical_contacts


        # Initializes a new {Scanners::WhoisTldEe} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisTldEe.new(content_for_scanner).parse
        end


      private

        def build_contact(element, type)
          node(element) do |raw|
            Record::Contact.new(
                :type           => type,
                :id             => element,
                :name           => raw["name"],
                :organization   => raw["org"],
                :created_on     => Time.parse(raw["created"])
            )
          end
        end

      end
    end
  end
end
