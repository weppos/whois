#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'


module Whois
  class Answer
    class Parser

      #
      # = whois.markmonitor.com parser
      #
      # Parser for the whois.markmonitor.com server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisMarkmonitorCom < Base

        property_not_supported :status


        # The server seems to provide only information for registered domains
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
          Answer::Registrar.new(
            :name => content_for_scanner[/Registrar Name: (.+)\n/, 1],
            :url  => content_for_scanner[/Registrar Homepage: (.+)\n/, 1]
          )
        end


        property_supported :registrant_contact do
          contact('Registrant:', Answer::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contact do
          contact('Administrative Contact:', Answer::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contact do
          contact('Technical Contact, Zone Contact:', Answer::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          content_for_scanner[/Domain servers in listed order:\n\n((?:\s*[^\s\n]+\n)+)/, 1].each_line.map do |ns|
            Answer::Nameserver.new(ns.strip)
          end
        end

        private

          def contact(element, type)
            info = content_for_scanner[/#{element}\n((.+\n){6})/, 1].each_line.map(&:strip)
            # 0 DNS Admin
            # 1 Google Inc.
            # 2 1600 Amphitheatre Parkway
            # 3 Mountain View CA 94043
            # 4 US
            # 5 dns-admin@google.com +1.6506234000 Fax: +1.6506188571
            city, state, zip = info[3].scan(/^(.+) ([A-Z]{2}) ([0-9]+)$/).first
            email, phone, fax = info[5].scan(/^(.+) (.+) Fax: (.+)$/).first
            Answer::Contact.new(
              :type => type,
              :name => info[0],
              :organization => info[1],
              :address => info[2],
              :city => city,
              :state => state,
              :zip => zip,
              :country_code => info[4],
              :email => email,
              :phone => phone,
              :fax => fax
            )
          end

      end

    end
  end
end
