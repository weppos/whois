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
      # = whois.dot.tk parser
      #
      # Parser for the whois.dot.tk server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisDotTk < Base

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
          if content_for_scanner =~ /Domain registered:\s+(.*)\n/
            DateTime.strptime($1, "%m/%d/%Y").to_time
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Record will expire on:\s+(.*)\n/
            DateTime.strptime($1, "%m/%d/%Y").to_time
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Domain Nameservers:\n((.+\n)+)\s+\n/
            $1.split("\n").map do |name|
              Record::Nameserver.new(:name => name.strip.downcase)
            end
          end
        end

      end

    end
  end
end
