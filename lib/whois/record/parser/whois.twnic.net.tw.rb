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

      #
      # = whois.twnic.net.tw
      #
      # Parser for the whois.twnic.net.tw server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisTwnicNetTw < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner.strip == "No Found")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Record created on ([^ ]+) .+\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Record expires on ([^ ]+) .+\n/
            Time.parse($1)
          end
        end

        property_supported :registrant_contacts do
          if content_for_scanner =~ /Registrant:\s+((.+\n)+)\n/
            lines = $1.split("\n").map(&:strip)
            name = lines[0]
            organization_email = lines[1].split("  ")
            organization = organization_email[0]
            email = organization_email[1]
            phone = lines[2]
            fax = lines[3]
            address = lines[4, 3]
            
            Record::Contact.new(
                :type         => Whois::Record::Contact::TYPE_REGISTRANT,
                :id           => nil,
                :name         => name,
                :organization => organization,
                :address      => address,
                :city         => nil,
                :zip          => nil,
                :state        => nil,
                :country_code => nil,
                :phone        => phone,
                :fax          => fax,
                :email        => email
            )
          end
        end

        property_supported :admin_contacts do
          if content_for_scanner =~ /Administrative Contact:\s+((.+\n)+)\n/
            lines = $1.split("\n").map(&:strip)
            name = lines[0]
            organization_email = lines[1].split("  ")
            organization = organization_email[0]
            email = organization_email[1]
            phone = lines[2]
            fax = lines[3]
            
            Record::Contact.new(
                :type         => Whois::Record::Contact::TYPE_ADMINISTRATIVE,
                :id           => nil,
                :name         => name,
                :organization => organization,
                :address      => nil,
                :city         => nil,
                :zip          => nil,
                :state        => nil,
                :country_code => nil,
                :phone        => phone,
                :fax          => fax,
                :email        => email
            )
          end
        end

        property_supported :technical_contacts do
          if content_for_scanner =~ /Technical Contact:\s+((.+\n)+)\n/
            lines = $1.split("\n").map(&:strip)
            name = lines[0]
            organization_email = lines[1].split("  ")
            organization = organization_email[0]
            email = organization_email[1]
            phone = lines[2]
            fax = lines[3]
            
            Record::Contact.new(
                :type         => Whois::Record::Contact::TYPE_TECHNICAL,
                :id           => nil,
                :name         => name,
                :organization => organization,
                :address      => nil,
                :city         => nil,
                :zip          => nil,
                :state        => nil,
                :country_code => nil,
                :phone        => phone,
                :fax          => fax,
                :email        => email
            )
          end
        end

        property_supported :nameservers do
          if content_for_scanner =~ /Domain servers in listed order:\n((.+\n)+)\n/
            $1.split("\n").map do |name|
              Record::Nameserver.new(:name => name.strip)
            end
          end
        end

      end

    end
  end
end
