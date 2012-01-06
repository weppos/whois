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
      # = whois.centralnic.net parser
      #
      # Parser for the whois.centralnic.net server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisCentralnicCom < Base

        # property_supported :disclaimer do
        #   if content_for_scanner =~ /(This whois service is provided by .*)\n/m
        #     $1.gsub("\n", " ")
        #   else
        #     raise ParserError, "Unexpected response trying to parse `:disclaimer' property. The parser might be outdated."
        #   end
        # end


        # property_supported :domain do
        #   if content_for_scanner =~ /Domain Name: (.*)\n/
        #     $1.strip
        #   elsif content_for_scanner =~ /^No match for (.*)\n/
        #     $1.strip
        #   else
        #     raise ParserError, "Unexpected response trying to parse `:domain' property. The parser might be outdated."
        #   end
        # end
        #
        # property_not_supported :domain_id


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          if content_for_scanner =~ /Status: (.+?)\n/
            case $1.downcase
              when "live" then :registered
              when "live, renewal in progress" then :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^No match for/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Record created on: (.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Record expires on: (.+)\n/
            Time.parse($1)
          end
        end


        # property_supported :registrar do
        #   if content_for_scanner =~ /Registrar: (.*) \((.*)\)\n/
        #     Record::Registrar.new(
        #       :id           => $1,
        #       :name         => $2,
        #       :organization => $2
        #     )
        #   end
        # end


        property_supported :nameservers do
          if content_for_scanner =~ /Domain servers in listed order:\n\n((.+\n)+)\n/
            $1.split("\n").map do |name|
              Record::Nameserver.new(name.strip.downcase)
            end
          end
        end

      end

    end
  end
end
