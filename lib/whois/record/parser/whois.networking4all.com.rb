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

      # Parser for the whois.networking4all.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNetworking4allCom < Base

        property_supported :created_on do
          if content_for_scanner =~ /Created date\.+:(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Updated date\.+:(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expiration date\.+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Administrative contact", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Technical contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end

        def build_contact(element, type)
          contact_content = content_for_scanner[/#{element}:\s+((.+\n)+)\n/, 1]
          Record::Contact.new(
              :type         => type,
              :id           => contact_content[/Handle\.+:(.+?)\n/, 1].to_s.strip,
              :name         => contact_content[/Name\.+:(.+?)\n/, 1].to_s.strip,
              :organization => contact_content[/Organization\.+:(.+?)\n/, 1].to_s.strip,
              :address      => contact_content[/Street\.+:(.+?)\n/, 1].to_s.strip,
              :city         => contact_content[/City\.+:(.+?)\n/, 1].to_s.strip,
              :zip          => contact_content[/Postalcode\.+:(.+?)\n/, 1].to_s.strip,
              :state        => contact_content[/Province\.+:(.+?)\n/, 1].to_s.strip,
              :country      => contact_content[/Country\.+:(.+?)\n/, 1].to_s.strip,
              :phone        => contact_content[/Phone\.+:(.+?)\n/, 1].to_s.strip,
              :fax          => contact_content[/Fax\.+:(.+?)\n/, 1].to_s.strip,
              :email        => contact_content[/E-mail\.+:(.+?)\n/, 1].to_s.strip
          ) 
        
        end
      end
    end
  end
end
