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

      # Parser for the whois.enom.com server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @since  2.5.0
      class WhoisEnomCom < Base

        property_not_supported :status

        # The server is contacted only in case of a registered domain.
        property_supported :available? do
          false
        end

        property_supported :registered? do
          true
        end


        property_supported :created_on do
          if content_for_scanner =~ /Creation date: (.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Expiration date: (.+)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          Record::Registrar.new(
            :name => "eNom Inc.",
            :url  => "http://www.enom.com/"
          )
        end

        property_supported :registrant_contacts do
          build_contact("Registrant Contact", Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Administrative Contact", Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact("Technical Contact", Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
         if content_for_scanner =~ /Name Servers:\n((\s+[^\s]+\n)+)/
            $1.split("\n").map do |line|
              Record::Nameserver.new(:name => line.strip)
            end
          end
        end


      private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}:\n((.+\n)+)/, 1)
          return unless match

          # 0 AdBrite, Inc.
          # 1 Host Master (hostmaster@adbrite.com)
          # 2 4159750916
          # 3 Fax: 
          # 4 731 Market Street, Suite 500
          # 5 San Francisco, CA 94103
          # 6 US

          lines = match.split("\n").map(&:lstrip)
          name, email = lines[1].match(/(.*)\((.*)\)/)[1..2].map(&:strip)
          fax = lines[3].match(/Fax: (.*)/)[1]
          city, state, zip = lines[-2].match(/(.*),(.+?)(\d*)$/)[1..3].map(&:strip)

          Record::Contact.new(
            :type         => type,
            :id           => nil,
            :name         => name,
            :organization => lines[0],
            :address      => lines[4..-3].join("\n"),
            :city         => city,
            :zip          => zip,
            :state        => state,
            :country_code => lines[-1],
            :phone        => lines[2],
            :fax          => fax,
            :email        => email
          )
        end

      end

    end
  end
end
