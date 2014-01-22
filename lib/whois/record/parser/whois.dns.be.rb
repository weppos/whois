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

      # Parser for the whois.dns.be server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisDnsBe < Base

        property_supported :domain do
          content_for_scanner.slice(/Domain:\s+(.+?)\n/, 1)
        end


        property_supported :status do
          if content_for_scanner =~ /Status:\s+(.+?)\n/
            case $1.downcase
            when "available"
              :available
            when "not available"
              :registered
            when "quarantine"
              :redemption
            when "out of service"
              :redemption
            when "not allowed"
              :invalid
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            Whois.bug!(ParserError, "Unable to parse status.")
          end
        end

        property_supported :available? do
          !invalid? && (status == :available)
        end

        property_supported :registered? do
          !invalid? && !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Registered:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :registrar do
          if (match = content_for_scanner.match(/Registrar:\s+Name:(.+?)\s*Website:(.+?)\n/))
            name, url = match.to_a[1..2]
            Record::Registrar.new(name: name.strip, url: url.strip)
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Nameservers:\s((.+\n)+)\n/
            $1.split("\n").map do |line|
              if line.strip =~ /(.+) \((.+)\)/
                Record::Nameserver.new(:name => $1, :ipv4 => $2)
              else
                Record::Nameserver.new(:name => line.strip)
              end
            end
          end
        end


        # Checks whether the response has been throttled.
        #
        # @return [Boolean]
        def response_throttled?
          !!(content_for_scanner =~ /^% (Excessive querying|Maximum queries per hour reached)/) ||
          response_blocked?
        end

        # Checks whether the server has been blocked.
        #
        # @return [Boolean]
        def response_blocked?
          !!(content_for_scanner =~ /^-3: IP address blocked/)
        end


        # NEWPROPERTY
        def invalid?
          cached_properties_fetch(:invalid?) do
            status == :invalid
          end
        end

      end

    end
  end
end
