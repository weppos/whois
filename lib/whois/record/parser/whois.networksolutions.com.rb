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

      # Parser for the whois.networksolutions.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @author Andrew Brampton <me@bramp.net>
      # @since  2.6.2
      class WhoisNetworksolutionsCom < Base

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
              :name         => 'Network Solutions',
              :organization => 'Network Solutions, LLC',
              :url          => 'http://www.networksolutions.com/'
          )
        end

        property_supported :registrant_contacts do
          build_contact('Registrant:', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('Administrative Contact', Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact('Technical Contact', Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
         if content_for_scanner =~ /Domain servers in listed order:\n\n((?:[^\n]+\n)+)/
            $1.split("\n").map do |line|
              #   NS01.XIF.COM                 63.240.200.70
              name, ipv4 = line.strip.split(" ")
              Record::Nameserver.new(:name => name.downcase, :ipv4 => ipv4)
            end
          end
        end

        def response_throttled?
          !!(content_for_scanner =~ /The IP address from which you have visited/)
        end

      private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}.*\n((.+\n){4,7})/, 1)
          return unless match

          # Split lines but don't strip them now because in some cases
          # we need the entire line, including extra-spaces.
          lines = match.split("\n")

          # 0 XIF Communications                    |  mpowers LLC
          # 1  1200 New Hampshire Avenue NW         |  21010 Southbank St #575
          # 2  Suite 410                            |  Potomac Falls, VA 20165
          # 3  Washington, DC 20036                 |  US
          # 4  US

          # 0 Communications, XIF ContactMiddleName   noc@xif.com   | mpowers LLC   michael@mpowers.net
          # 1 XIF Communications                                    | 21010 Southbank St #575
          # 2 1200 New Hampshire Avenue NW                          | Potomac Falls, VA 20165
          # 3 Suite 410                                             | US
          # 4 Washington, DC 20036                                  | +1.5712832829
          # 5 US
          # 6 202-463-7200 fax: 202-318-4003

          # Does the first line end in something that looks like a email address?
          if lines[0].to_s =~ /\S+@\S+$/
            # p lines.shift
            # The record has a extra name and number line
            name, email = lines.shift.scan(/^(.+)\s(\S+@\S+)$/).first
            name = name.strip if name
          end

          lines.each(&:strip!)

          # Does the last line contains the word fax, or has >9 digits
          if lines[-1].to_s =~ / fax: /
            phone, fax  = lines.pop.to_s.scan(/^(.+) fax: (.+)$/).first
            phone = phone.strip
            fax   = fax.strip
          elsif lines[-1].to_s.gsub(/[^\d]+/, '').length > 9
            phone = lines.pop
          end

          country_code = lines.pop
          city, state, zip = lines.pop.scan(/^(.+), ([A-Z]{2}) ([\sA-Z0-9\-]+)$/).first
          organization = lines.shift if lines.length >= 2

          address = lines.join("\n")

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
