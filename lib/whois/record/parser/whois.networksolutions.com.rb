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

      # Parser for the whois.networksolutions.com server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @author Andrew Brampton <me@bramp.net>
      # 
      class WhoisNetworksolutionsCom < Base

        property_not_supported :status

        # The server is contacted only in case of a registered domain.
        property_supported :available? do
          false
        end

        property_supported :registered? do
          !available?
        end

        property_supported :registrar do
          Record::Registrar.new(
              :name => 'Network Solutions',
              :organization => 'Network Solutions, LLC',
              :url  => 'http://www.networksolutions.com/'
          )
        end

        property_supported :created_on do
          if content_for_scanner =~ /Record created on (.+)\.\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Database last updated on (.+)\.\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Record expires on (.+)\.\n/
            Time.parse($1)
          end
        end

        property_supported :registrant_contacts do
          build_contact('Registrant:', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('Administrative Contact', Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact('Technical Contact', Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
         if content_for_scanner =~ /Domain servers in listed order:\n\n((?:[^\n]+\n)+)/
            $1.split("\n").map do |line|
              #   NS01.XIF.COM                 63.240.200.70
              dns = line.strip.split(" ")
              Record::Nameserver.new(dns[0].downcase, dns[1])
            end
          end
        end


      private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}.*\n((.+\n){5,7})/, 1)
          return unless match

          lines = match.split("\n").map(&:strip)

          # 0 XIF Communications
          # 1  1200 New Hampshire Avenue NW
          # 2  Suite 410
          # 3  Washington, DC 20036
          # 4  US
          
          # 0 Communications, XIF ContactMiddleName   noc@xif.com
          # 1 XIF Communications
          # 2 1200 New Hampshire Avenue NW
          # 3 Suite 410
          # 4 Washington, DC 20036
          # 5 US
          # 6 202-463-7200 fax: 202-318-4003

          if lines.length == 7 then
            # The record has a extra name and number line
            name, email = lines[0].scan(/^(.+)\s(\S+@\S+)$/).first
            phone, fax  = lines[6].scan(/^(.+) fax: (.+)$/).first
            name = name.strip
            lines.shift
          end

          organization = lines[0]
          address = lines[1] + "\n" + lines[2]
          city, state, zip = lines[3].scan(/^(.+), ([A-Z]{2}) ([0-9]+)$/).first
          country_code = lines[4]

          Record::Contact.new(
            :type => type,
            :name => name,
            :organization => organization,
            :address => address,
            :city => city,
            :state => state,
            :zip => zip,
            :country_code => country_code,
            :email => email,
            :phone => phone,
            :fax => fax
          )
        end
      end
    end
  end
end
