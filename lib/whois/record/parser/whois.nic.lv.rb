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

      # = whois.nic.lv parser
      #
      # Parser for the whois.nic.lv server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicLv < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
           !!(content_for_scanner =~ /Status: free/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          if content_for_scanner =~ /Changed:\s+(.*)\n/
            Time.parse($1.split(" ", 2).last)
          end
        end

        property_not_supported :expires_on
        

        property_supported :nameservers do
          content_for_scanner.scan(/Nserver:\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(name)
          end
        end

      end

    end
  end
end
