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
      # = whois.sgnic.sg parser
      #
      # Parser for the whois.sgnic.sg server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisSgnicSg < Base

        property_supported :status do
          content_for_scanner.scan(/^\s+Domain Status:\s+(.+?)\n/).flatten
        end

        property_supported :available? do
          !!(content_for_scanner.strip == "Domain Not Found")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /^\s+Creation Date:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /^\s+Expiration Date:\s+(.*)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Name Servers:\n((.+\n)+)\n/
            values = case value = $1.downcase
            # schema-1
            when /^(?:\s+([\w.-]+)\n){2,}/
              value.scan(/\s+([\w.-]+)\n/).map do |match|
                { :name => match[0] }
              end
            when /^(?:\s+([\w.-]+)\s+\((.+)\)\n){2,}/
              value.scan(/\s+([\w.-]+)\s+\((.+)\)\n/).map do |match|
                { :name => match[0], :ipv4 => match[1] }
              end
            # schema-2
            when /^(?:\s+([\w.-]+)){2,}/
              value.strip.split(/\s+/).map do |name|
                { :name => name }
              end
            else
              Whois.bug!(ParserError, "Unknown nameservers format `#{value}'")
            end

            values.map do |params|
              Record::Nameserver.new(params)
            end
          end
        end

      end

    end
  end
end
