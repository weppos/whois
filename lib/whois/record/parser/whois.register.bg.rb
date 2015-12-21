#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.register.bg server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisRegisterBg < Base

        property_supported :status do
          if content_for_scanner =~ /registration status:\s+(.+?)\n/
            case $1.downcase
            when "registered"
              :registered
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /Domain name (.+?) does not exist/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /activated on:\s+(.*?)\n/
            # parse_time("30/06/2003 00:00:00")
            # => ArgumentError: argument out of range
            parse_time($1.gsub("/", "-"))
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /expires at:\s+(.*?)\n/
            # parse_time("30/06/2003 00:00:00")
            # => ArgumentError: argument out of range
            parse_time($1.gsub("/", "-"))
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /NAME SERVER INFORMATION:\n((.+\n)+)\s+\n/
            $1.split("\n").map do |line|
              if line =~ /(.+) \((.+)\)/
                Record::Nameserver.new(:name => $1, :ipv4 => $2)
              else
                Record::Nameserver.new(:name => line.strip)
              end
            end
          end
        end

      end

    end
  end
end
