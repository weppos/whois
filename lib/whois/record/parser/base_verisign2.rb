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

      # Parser for the secondary verisign domains server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class BaseVerisign2 < Base


        property_supported :domain do
          if content_for_scanner =~ /Domain Name:(.+)\n/
            $1.downcase.strip
          end
        end

        property_supported :domain_id do
          if content_for_scanner =~ /Registry Domain ID:\s+(.+?)\n/
            $1
          end
        end
          
        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^No match for/)
        end

        property_supported :registered? do
          !available?
        end

        property_supported :registrar do
          Whois::Record::Registrar.new(
            id:     content_for_scanner[/Registrar IANA ID:(.+?)\n/, 1].to_s.strip,
            name:   content_for_scanner[/Registrar:(.+?)\n/, 1].to_s.strip,
            url:    content_for_scanner[/Registrar URL:(.+?)\n/, 1].to_s.strip,
            )
        end

        property_supported :created_on do
          if content_for_scanner =~ /Creation Date:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Updated Date:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Admin", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("Tech", Whois::Record::Contact::TYPE_TECHNICAL)
        end

        def build_contact(element, type)

          Record::Contact.new(
              :type         => type,
              :id           => content_for_scanner[/Registry #{element} ID:(.+?)\n/, 1].to_s.strip,
              :name         => content_for_scanner[/#{element} Name:(.+?)\n/, 1].to_s.strip,
              :organization => content_for_scanner[/#{element} Organization:(.+?)\n/, 1].to_s.strip,
              :address      => content_for_scanner[/#{element} Street:(.+?)\n/, 1].to_s.strip,
              :city         => content_for_scanner[/#{element} City:(.+?)\n/, 1].to_s.strip,
              :zip          => content_for_scanner[/#{element} Postal Code:(.+?)\n/, 1].to_s.strip,
              :state        => content_for_scanner[/#{element} State\/Province:(.+?)\n/, 1].to_s.strip,
              :country_code => content_for_scanner[/#{element} Country:(.+?)\n/, 1].to_s.strip,
              :phone        => content_for_scanner[/#{element} Phone:(.+?)\n/, 1].to_s.strip,
              :fax          => content_for_scanner[/#{element} Fax:(.+?)\n/, 1].to_s.strip,
              :email        => content_for_scanner[/#{element} Email:(.+?)\n|#{element} E-mail:(.+?)\n/, 1].to_s.strip
          ) 
        
        end
      end
  	end
  end
end
