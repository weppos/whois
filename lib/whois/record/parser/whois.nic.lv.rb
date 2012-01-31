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
      class WhoisNicLv < Base

        property_supported :status do
          if available?
            :free
          else
            :active
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
