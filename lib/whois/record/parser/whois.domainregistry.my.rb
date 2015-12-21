#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.domainregistry.my server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      class WhoisDomainregistryMy < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /Domain Name [^ ]+ does not exist in database/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /\[Record Created\]\s+(.+?)\n/
            parse_time($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /\[Record Last Modified\]\s+(.+?)\n/
            parse_time($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /\[Record Expired\]\s+(.+?)\n/
            parse_time($1)
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/\[(?:Primary|Secondary) Name Server\](?:.+?)\n(.+\n)/).flatten.map do |line|
            name, ipv4 = line.strip.split(/\s+/)
            Record::Nameserver.new(:name => name, :ipv4 => ipv4)
          end
        end

      end

    end
  end
end
