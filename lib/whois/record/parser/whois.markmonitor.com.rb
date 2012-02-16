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

      # Parser for the whois.markmonitor.com server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      class WhoisMarkmonitorCom < Base

        property_not_supported :status

        # The server is contacted only in case of a registered domain.
        property_supported :available? do
          false
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created on\.+: (.+)\.\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Record last updated on\.+: (.+)\.\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expires on\.+: (.+)\.\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          Record::Registrar.new(
            :name => content_for_scanner.slice(/Registrar Name: (.+)\n/, 1),
            :url  => content_for_scanner.slice(/Registrar Homepage: (.+)\n/, 1)
          )
        end

        property_supported :registrant_contacts do
          build_contact('Registrant:', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('Administrative Contact:', Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact('Technical Contact, Zone Contact:', Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
         if content_for_scanner =~ /Domain servers in listed order:\n\n((?:\s*[^\s\n]+\n)+)/
            $1.split("\n").map do |line|
              Record::Nameserver.new(line.strip)
            end
          end
        end


      private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}\n((.+\n){6})/, 1)
          return unless match

          lines = match.split("\n").map(&:strip)

          # 0 DNS Admin
          # 1 Google Inc.
          # 2 1600 Amphitheatre Parkway
          # 3 Mountain View CA 94043
          # 4 US
          # 5 dns-admin@google.com +1.6506234000 Fax: +1.6506188571
          city, state, zip = lines[3].scan(/^(.+) ([A-Z]{2}) ([0-9]+)$/).first
          email, phone, fax = lines[5].scan(/^(.+) (.+) Fax: (.+)$/).first
          Record::Contact.new(
            :type => type,
            :name => lines[0],
            :organization => lines[1],
            :address => lines[2],
            :city => city,
            :state => state,
            :zip => zip,
            :country_code => lines[4],
            :email => email,
            :phone => phone,
            :fax => fax
          )
        end

      end

    end
  end
end
