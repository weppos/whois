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
      # = whois.nic.as parser
      #
      # Parser for the whois.nic.as server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicAs < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /Domain Not Found/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :nameservers do
          if content_for_scanner =~ /Nameservers:\s((.+\n)+)\n/
            $1.split("\n").reject { |value| value.strip.empty? }.map do |line|
              line.strip =~ /(.+) \((.+)\)/
              Record::Nameserver.new(:name => $1, :ipv4 => $2)
            end
          end
        end

      end

    end
  end
end
