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

      # Parser for the whois.hkirc.hk server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisHkircHk < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          content_for_scanner.strip == 'The domain has not been registered.'
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Domain Name Commencement Date:\s(.+?)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Expiry Date:\s(.+?)\n/
            time = $1.strip
            Time.parse(time) unless time == 'null'
          end
        end

        # There are typically no contact information for the registrar for whois domains.
        # In this case, I decided to add the two in organization. 
        # FIXME if this causes problems.
        property_supported :registrar do
          if content_for_scanner =~ /Registrar Contact Information:\s+(.+?)\n/
            Record::Registrar.new(
              organization: $1,
              name: content_for_scanner[/Registrar Name:\s+(.+?)\n/, 1]
              )
          end
        end

        property_supported :domain do
          if content_for_scanner =~ /Domain Name:\s+(.+?)\n/
            $1
          end
        end

        property_supported :registrant_contacts do
          if content_for_scanner =~ /Registrant Contact Information:\n\n((.+\n)+)\n/
            reg_contact_content = $1

            city = ""
            address = ""
            state = ""

            # Address comes in one line like the following :
            # ROOM 15-18, 16/F., DELTA HOUSE, 3 ON YIU STREET, SHATIN, N.T., HONG KONG.
            # However, addresses outside of hong kong comes out in a different form.
            # Thus 'address' will always have the whole address
            if content_for_scanner =~ /Address:\s+(.+?)\n/
              address_line = $1.split(",").map(&:strip)
              state   = address_line[-2]
              city    = address_line[-3]
              address = address_line.join(", ")
            end           

            Record::Contact.new(
              :type => Record::Contact::TYPE_REGISTRANT,
              :name => reg_contact_content[/Company English Name \(.+\): (.+?)\n/, 1],
              :email => reg_contact_content[/Email:\s+(.+?)\n/, 1].strip,
              :zip => nil,
              :address => address,
              :city => city,
              :state => state,
              :country => reg_contact_content[/Country:\s+(.+?)\n/, 1],
              :created_on => Time.parse(reg_contact_content[/Domain Name Commencement Date:\s+(.+?)\n/, 1])
              )
            
          end
        end

        property_supported :admin_contacts do
          if content_for_scanner =~ /Administrative Contact Information:\n\n((.+\n)+)\n/
            adm_contact_content = $1

            city = ""
            address = ""
            state = ""

            # Address comes in one line like the following :
            # ROOM 15-18, 16/F., DELTA HOUSE, 3 ON YIU STREET, SHATIN, N.T., HONG KONG. 
            if content_for_scanner =~ /Address:\s+(.+?)\n/
              address_line = $1.split(",").map(&:strip)
              state   = address_line[-2]
              city    = address_line[-3]
              address = address_line[0..-4].join(", ")
            end            

            Record::Contact.new(
              :type => Record::Contact::TYPE_ADMINISTRATIVE,
              :id => adm_contact_content[/Account Name:\s+(.+?)\n/, 1],
              :name => adm_contact_content[/Given name:\s+(.+?)\n/, 1].strip + " " + adm_contact_content[/Family name:\s+(.+?)\n/, 1].strip,
              :organization => adm_contact_content[/Company name:\s+(.+?)\n/, 1],
              :email => adm_contact_content[/Email:\s+(.+?)\n/, 1],
              :zip => nil,
              :address => address,
              :city => city,
              :state => state,
              :country => adm_contact_content[/Country:\s+(.+?)\n/, 1],
              :phone => adm_contact_content[/Phone:\s+(.+?)\n/, 1],
              :fax => adm_contact_content[/Fax:\s+(.+?)\n/, 1]
              )
            
          end
        end

        property_supported :technical_contacts do
          if content_for_scanner =~ /Technical Contact Information:\n\n((.+\n)+)\n/
            tech_contact_content = $1

            city = ""
            address = ""
            state = ""

            # Address comes in one line like the following :
            # ROOM 15-18, 16/F., DELTA HOUSE, 3 ON YIU STREET, SHATIN, N.T., HONG KONG. 
            if content_for_scanner =~ /Address:\s+(.+?)\n/
              address_line = $1.split(",").map(&:strip)
              state   = address_line[-2]
              city    = address_line[-3]
              address = address_line[0..-4].join(", ")
            end            

            Record::Contact.new(
              :type => Record::Contact::TYPE_TECHNICAL,
              :name => tech_contact_content[/Family name:\s+(.+?)\n/, 1].strip,
              :organization => tech_contact_content[/Company name:\s+(.+?)\n/, 1],
              :email => tech_contact_content[/Email:\s+(.+?)\n/, 1],
              :zip => nil,
              :address => address,
              :city => city,
              :state => state,
              :country => tech_contact_content[/Country:\s+(.+?)\n/, 1],
              :phone => tech_contact_content[/Phone:\s+(.+?)\n/, 1],
              :fax => tech_contact_content[/Fax:\s+(.+?)\n/, 1]
              )    
          end
        end

        property_supported :nameservers do
          if content_for_scanner =~ /Name Servers Information:\n\n((.+\n)+)\n/
            $1.split("\n").map do |name|
              Record::Nameserver.new(:name => name.strip.downcase)
            end
          end
        end

        property_supported :disclaimer do
          if content_for_scanner =~ /WHOIS Terms of Use\s+((.+\n)+)/
            $1
          end
        end

      end

    end
  end
end
