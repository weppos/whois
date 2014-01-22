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

      #
      # = whois.nic.cl parser
      #
      # Parser for the whois.nic.cl server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicCl < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
           !!(content_for_scanner =~ /^(.+?): no existe$/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        # TODO: custom date format with foreign month names
        # property_supported :updated_on do
        #   if content_for_scanner =~ /changed:\s+(.*)\n/
        #     Time.parse($1.split(" ", 2).last)
        #   end
        # end

        property_not_supported :expires_on


        property_supported :nameservers do
          if content_for_scanner =~ /Servidores de nombre \(Domain servers\):\n((.+\n)+)\n/
            $1.split("\n").map do |line|
              line.strip!
              line =~ /(.+) \((.+)\)/
              Record::Nameserver.new(:name => $1, :ipv4 => $2)
            end
          end
        end

      end

    end
  end
end
