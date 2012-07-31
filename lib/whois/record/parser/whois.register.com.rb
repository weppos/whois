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

      # Parser for the whois.register.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      class WhoisRegisterCom < Base

        property_not_supported :status

        # The server is contacted only in case of a registered domain.
        property_supported :available? do
          false
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created on\.+: (.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Expires on\.+: (.+)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          Record::Registrar.new(
            :name         => 'Register.com',
            :organization => 'Register.com',
            :url          => 'http://www.register.com/'
          )
        end

        property_supported :registrant_contacts do
          build_contact('Registrant:', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('Administrative Contact:', Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact('Technical  Contact:', Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          if content_for_scanner =~ /DNS Servers:\n((.+\n)+)\n/
            $1.split("\n").map do |line|
              Record::Nameserver.new(:name => line.strip)
            end
          end
        end


      private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}\n((.+\n){7})/, 1)
          return unless match

          lines = match.split("\n").map(&:strip)

          # 0 Register.Com, Inc.
          # 1 Domain Registrar
          # 2 575 8th Avenue 
          # 3 New York, NY 10018
          # 4 US
          # 5 Phone: +1.9027492701
          # 6 Email: domainregistrar@register.com
          city, state, zip = lines[3].scan(/^(.+), ([A-Z]{2}) ([0-9]+)$/).first
          phone = lines[5].slice(/Phone: (.+)/, 1)
          email = lines[6].slice(/Email: (.+)/, 1)
          Record::Contact.new(
            :type         => type,
            :name         => lines[1],
            :organization => lines[0],
            :address      => lines[2],
            :city         => city,
            :state        => state,
            :zip          => zip,
            :country_code => lines[4],
            :email        => email,
            :phone        => phone
          )
        end

      end

    end
  end
end
