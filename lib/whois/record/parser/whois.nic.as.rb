#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_cocca'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.as server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
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
          !!(content_for_scanner =~ /NOT FOUND/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          nil # TODO
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          nil # TODO
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Name servers:\n((.+\n)+)\n/
            $1.strip.split("\n").map do |line|
              name, ipv4, ipv6 = line.strip.split(/\s+/)
              Record::Nameserver.new(name: name, ipv4: ipv4, ipv6: ipv6)
            end
          end
        end

      end

    end
  end
end
