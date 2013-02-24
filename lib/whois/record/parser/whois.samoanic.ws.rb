#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      #
      # = whois.samoanic.ws parser
      #
      # Parser for the whois.samoanic.ws server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisSamoanicWs < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No match for/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /\s+Domain Created:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /\s+Domain Last Updated:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /\s+Domain Currently Expires:\s+(.*)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Current Nameservers:\n\n((.+\n)+)\n/
            $1.split("\n").map do |name|
              Record::Nameserver.new(:name => name.strip.downcase)
            end
          end
        end

      end

    end
  end
end
