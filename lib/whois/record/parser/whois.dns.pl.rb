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

      # Parser for the whois.dns.pl server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisDnsPl < Base

        property_supported :domain do
          if content_for_scanner =~ /DOMAIN NAME:\s+(.+)\n/
            $1
          end
        end

        property_not_supported :domain_id


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
          if content_for_scanner =~ /renewal date:\s+(.+?)\n/ && $1 != "not defined"
            Time.parse($1)
          end
        end


        property_supported :registrar do
          match = content_for_scanner.slice(/REGISTRAR:\n((.+\n)+)\n/, 1)
          return unless match

          lines = match.split("\n")
          Record::Registrar.new(
            :name         => lines[0]
          )
        end

        property_not_supported :registrant_contacts

        property_not_supported :admin_contacts

        property_supported :technical_contacts do
          build_contact("TECHNICAL CONTACT", Record::Contact::TYPE_TECHNICAL)
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

        # Checks whether the response has been throttled.
        #
        # @return [Boolean]
        #
        # @example
        #   Looup quota exceeded.
        #
        def response_throttled?
          !!(content_for_scanner =~ /^request limit exceeded for/)
        end


      private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}:\n((.+\n)+)\n/, 1)
          return unless match

          values = parse_contact_block(match.split("\n"))
          zip, city = values["city"].match(/(.+?) (.+)/)[1..2]

          Record::Contact.new(
            :type         => type,
            :id           => values["handle"],
            :name         => nil,
            :organization => values["company"],
            :address      => values["street"],
            :city         => city,
            :zip          => zip,
            :state        => nil,
            :country_code => values["location"],
            :phone        => values["phone"],
            :fax          => values["fax"],
            :email        => nil
          )
        end

        def parse_contact_block(lines)
          key  = nil
          hash = {}
          lines.each do |line|
            if line =~ /(.+):(.+)/
              hash[key = $1] = $2.strip
            else
              hash[key] += "\n#{line.strip}"
            end
          end
          hash
        end

      end

    end
  end
end
