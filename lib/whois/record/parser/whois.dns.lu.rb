#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.dns.lu server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisDnsLu < Base

        property_supported :status do
          if content_for_scanner =~ /domaintype:\s+(.+)\n/
            case $1.downcase
              when "active" then :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /% No such domain/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /registered:\s+(.*)\n/
            # Force the parser to use the dd/mm/yyyy format.
            Time.utc(*$1.split("/").reverse)
          end
        end

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |line|
            if line =~ /(.+) \[(.+)\]/
              Record::Nameserver.new(:name => $1, :ipv4 => $2)
            else
              Record::Nameserver.new(:name => line)
            end
          end
        end

      end

    end
  end
end
