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

      # Parser for the whois.dot.cf server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisDotCf < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /domain name not known/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Domain registered:\s(.+)\n/
            Time.strptime($1, "%m/%d/%Y")
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Record will expire on:\s(.+)\n/
            value = $1.strip
            Time.strptime(value, "%m/%d/%Y") if value.present?
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Domain Nameservers:\n((.+\n)+)\s+\n/
            $1.split("\n").map do |name|
              Record::Nameserver.new(name: name.strip.downcase)
            end
          end
        end

      end

    end
  end
end
