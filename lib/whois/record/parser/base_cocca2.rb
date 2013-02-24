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
      class BaseCocca2 < Base

        property_supported :domain do
          content_for_scanner =~ /Domain Name: (.+)\n/
          $1 || Whois.bug!(ParserError, "Unable to parse domain.")
        end

        property_not_supported :domain_id

        # TODO: /pending delete/ => :redemption
        # TODO: /pending purge/  => :redemption
        property_supported :status do
          list = statuses
          case
            when list.empty?
              Whois.bug!(ParserError, "Unable to parse status.")
            when list.include?("available")
              :available
            when list.include?("ok")
              :registered
            else
              Whois.bug!(ParserError, "Unknown status `#{list.join(", ")}'.")
          end
        end

        property_supported :available? do
          status == :available
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Creation Date: (.+?)\n/
            parse_time($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Updated Date: (.+?)\n/
            parse_time($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Registry Expiry Date: (.+?)\n/
            parse_time($1)
          end
        end


        property_supported :registrar do
          if content_for_scanner =~ /Sponsoring Registrar: (.+?)\n/
            Record::Registrar.new(
                :name         => $1,
                :organization => nil,
                :url          => content_for_scanner.slice(/Sponsoring Registrar URL: (.+)\n/, 1)
            )
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/Name Server: (.+)\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name)
          end
        end


        def statuses
          content_for_scanner.scan(/Domain Status: (.+)\n/).flatten.map(&:downcase)
        end


        private

        def parse_time(value)
          # Hack to remove usec. Do you know a better way?
          Time.utc(*Time.parse(value).to_a)
        end

      end

    end
  end
end
