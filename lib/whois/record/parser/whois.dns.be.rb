#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      #
      # = whois.dns.be parser
      #
      # Parser for the whois.dns.be server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisDnsBe < Base

        property_supported :status do
          if content_for_scanner =~ /Status:\s+(.+?)\n/
            case $1.downcase
              when "registered" then :registered
              when "quarantine" then :redemption
              #when "blocked"    then :registered
              when "out of service" then :redemption
              #when "withdrawn"  then :registered
              #when "reserved"   then :registered
              when "free"       then :available
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            Whois.bug!(ParserError, "Unable to parse status.")
          end
        end

        property_supported :available? do
          (status == :available)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Registered:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :nameservers do
          if content_for_scanner =~ /Nameservers:\s((.+\n)+)\n/
            $1.split("\n").map do |line|
              if line.strip =~ /(.+) \((.+)\)/
                Record::Nameserver.new($1, $2)
              else
                Record::Nameserver.new(line.strip)
              end
            end
          end
        end


        # Checks whether the response has been throttled.
        #
        # @return [Boolean]
        def response_throttled?
          !!(content_for_scanner =~ /^% (Excessive querying|Maximum queries per hour reached)/)
        end

      end

    end
  end
end
