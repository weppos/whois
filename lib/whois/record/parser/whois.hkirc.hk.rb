#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/base_icann_compliant'

module Whois
  class Record
    class Parser

      # Parser for the whois.hkirc.hk server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisHkircHk < Base
        include Scanners::Scannable
        self.scanner = Scanners::BaseIcannCompliant

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          content_for_scanner.strip == 'The domain has not been registered.'
        end

        property_supported :registered? do
          !available?
        end


        property_supported :domain do
          node("Domain Name")
        end

        property_supported :created_on do
          Time.parse(node("Domain Name Commencement Date"))
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner = node("Expiry Date")
            time = content_for_scanner.strip
            Time.parse(time) unless time == 'null'
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Name Servers Information:\n\n((.+\n)+)\n/
            $1.split("\n").map do |name|
              Record::Nameserver.new(:name => name.strip.downcase)
            end
          end
        end

      end

    end
  end
end
