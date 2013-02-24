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
      # = whois.ja.net parser
      #
      # Parser for the whois.ja.net server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisJaNet < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^No such domain (.+)/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /^Entry created:\n\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /^Entry updated:\n\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /^Renewal date:\n\s+(.+?)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Servers:\n((.+\n)+)\n/
            $1.split("\n").map do |line|
              name, ipv4 = line.strip.downcase.split("\t")
              Record::Nameserver.new(:name => name, :ipv4 => ipv4)
            end
          end
        end

      end

    end
  end
end
