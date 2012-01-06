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
      # = whois.eu parser
      #
      # Parser for the whois.eu server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisEu < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /Status:\s+AVAILABLE/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        # Nameservers are listed in the following formats:
        #
        #   Name servers:
        #           dns1.servicemagic.eu
        #           dns2.servicemagic.eu
        #
        #   Name servers:
        #           dns1.servicemagic.eu (91.121.133.61)
        #           dns2.servicemagic.eu (91.121.103.77)
        #
        property_supported :nameservers do
          if content_for_scanner =~ /Name\sservers:\s((.+\n)+)\n/
            $1.split("\n").map do |line|
              if line.strip =~ /(.+) \((.+)\)/
                Record::Nameserver.new($1, $2)
              else
                Record::Nameserver.new(line.strip)
              end
            end
          end
        end

      end

    end
  end
end
