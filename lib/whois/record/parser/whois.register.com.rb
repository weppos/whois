#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
# Copyright (c) 2012 SophosLabs http://www.sophos.com
#++
require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.register.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @since 2.4.0
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
          if content_for_scanner =~ /Record created on (.+)\.\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Record expires on (.+)\.\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          Record::Registrar.new(
            :name => "Register.com",
            :organization => "REGISTER.COM, INC.",
            :url  => "www.register.com"
          )
        end

        property_supported :registrant_contacts do
          build_contact('Registrant:', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('Administrative Contact:', Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact('Technical\s+Contact:', Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :nameservers do
          if content_for_scanner =~ /DNS Servers:\n((?:\s*[^\s\n]+\n)+)/
            $1.split("\n").map do |line|
              Record::Nameserver.new(line.strip)
            end
          end
        end

      private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}\n((.+\n)+)\n/, 1)
          return unless match

          lines = match.split("\n").map(&:strip)

          #Organization
          #Name
          #Address
          #City, State Zip
          #Country
          #Phone: phone
          #Email: email

          organization = lines[0].strip
          name = lines[1].strip
          address = lines[2].strip
          
          city, state, zip = lines[3].scan(/^(.+), ([A-Z]{2}) ([^\n]+)$/).first
          phone  = lines[5].split(':').last.strip
          email  = lines[6].split(':').last.strip

          Record::Contact.new(
            :type         => type,
            :name         => name,
            :organization => organization,
            :address      => address,
            :city         => city,
            :state        => state,
            :zip          => zip,
            :country_code => lines[4],
            :email        => email,
            :phone        => phone,
            :fax          => nil
          )
        end

      end

    end
  end
end
