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

      # Parser for the whois.kenic.or.ke server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisKenicOrKe < Base

        property_supported :status do
          if content_for_scanner =~ /Status:\s+(.+?)\n/
            case $1.downcase
            when "active"
              :registered
            when "not registered"
              :available
            when "this whois server does not have any records for that zone."
              :invalid
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            Whois.bug!(ParserError, "Unable to parse status.")
          end
        end

        property_supported :available? do
          !invalid? && status == :available
        end

        property_supported :registered? do
          !invalid? && !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created:\s+(.+?)\n/
            parse_time($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Modified:\s+(.+?)\n/
            parse_time($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expires:\s+(.+?)\n/
            parse_time($1)
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Name Servers:\n((.+\n)+)\n/
            $1.split("\n").map do |name|
              Record::Nameserver.new(:name => name.strip)
            end
          end
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
