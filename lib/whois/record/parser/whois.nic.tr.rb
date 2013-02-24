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
      # = whois.nic.tr parser
      #
      # Parser for the whois.nic.tr server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicTr < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No match found for "(.+)"/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created on\.+:\s+(.+)\n/
            time = Time.parse($1)
            Time.utc(time.year, time.month, time.day)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Expires on\.+:\s+(.+)\n/
            time = Time.parse($1)
            Time.utc(time.year, time.month, time.day)
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Domain Servers:\n((.+\n)+)\n/
            $1.split("\n").map do |line|
              name, ipv4 = line.split(/\s+/)
              Record::Nameserver.new(:name => name, :ipv4 => ipv4)
            end
          end
        end

      end

    end
  end
end
