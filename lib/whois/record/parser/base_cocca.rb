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

      # Base parser for CoCCA servers.
      #
      # @abstract
      class BaseCocca < Base

        property_supported :domain do
          content_for_scanner =~ /Query:\s+(.+?)\n/
          $1 || Whois.bug!(ParserError, "Unable to parse domain.")
        end

        property_not_supported :domain_id


        property_supported :status do
          if content_for_scanner =~ /Status:\s+(.+?)\n/
            case $1.downcase
            when "active"
              :registered
            when "delegated"
              :registered
            when "not registered"
              :available
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            Whois.bug!(ParserError, "Unable to parse status.")
          end
        end

        property_supported :available? do
          status == :available
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Modified:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expires:\s+(.+?)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          if content_for_scanner =~ /Registrar Name: (.+)\n/
            Record::Registrar.new(
                :name         => $1,
                :organization => nil,
                :url          => content_for_scanner.slice(/Registration URL: (.+)\n/, 1)
            )
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Name Servers:\n((.+\n)+)\n/
            $1.split("\n").map do |name|
              Record::Nameserver.new(:name => name.strip)
            end
          end
        end

      end

    end
  end
end
