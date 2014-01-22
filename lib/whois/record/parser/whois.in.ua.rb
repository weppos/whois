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

      # Parser for the whois.in.ua server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisInUa < Base

        property_supported :status do
          if content_for_scanner =~ /status:\s+(.+?)\n/
            case $1.split("-").first.downcase
            when "ok"
              :registered
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No records found for object/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          if content_for_scanner =~ /changed:\s+(.*)\n/
            time = $1.split(" ").last
            Time.strptime(time, "%Y%m%d%H%M%S")
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /status:\s+(.*)\n/
            time = $1.split(" ").last
            Time.strptime(time, "%Y%m%d%H%M%S")
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(name: name.strip.downcase)
          end
        end

      end

    end
  end
end
