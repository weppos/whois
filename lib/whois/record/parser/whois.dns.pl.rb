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
      # = whois.dns.pl parser
      #
      # Parser for the whois.dns.pl server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisDnsPl < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^No information available about domain name/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /created:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /last modified:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /renewal date:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :nameservers do
          content_for_scanner.scan(/nameservers:\s+(.+)\n(.+)\n/).flatten.map do |line|
            line.strip!
            if line =~ /(.+) \[(.+)\]/
              Record::Nameserver.new(:name => $1.chomp("."), :ipv4 => $2)
            else
              Record::Nameserver.new(:name => line.chomp("."))
            end
          end
        end

      end

    end
  end
end
