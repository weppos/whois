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

      # Parser for the whois.jprs.jp server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisJprsJp < Base

        # Disclaimers start with [JPRS ...
        property_supported :disclaimer do
          if content_for_scanner =~ /(\[ JPRS+(.+\n)+)/
            lines = $1.split("\n").map(&:strip)
            rtn = ""
            for line in lines
              if line =~ /\[(.+)\]/
                rtn += $1.strip
              end
            end
            rtn
          end
        end

        property_supported :status do
          if content_for_scanner =~ /\[Status\]\s+(.+)\n/
            case $1.downcase
            when "active"
              :registered
            when "reserved"
              :reserved
            when "to be suspended"
              :redemption
            when "suspended"
              :expired
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          elsif content_for_scanner =~ /\[State\]\s+(.+)\n/
            case $1.split(" ").first.downcase
            when "connected", "registered"
              :registered
            when "deleted"
              :suspended
            when "reserved"
              :reserved
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
         else
            :available
          end
        end

        property_supported :domain do
          if content_for_scanner =~ /\[Domain Name\]\s+(.+)\n/
            @domain = $1
          end
        end

        property_supported :registrar do
          name = ""
          url = ""
          org = ""
          if content_for_scanner =~ /\[Registrant\](.+)\n/
            name = $1.strip
          end

          if content_for_scanner =~ /\[Organization\](.+)\n/
            org = $1.strip
          end


          if content_for_scanner =~ /\[Web Page\](.+)\n/
            url = $1.strip
          end

          lines = $1
          Record::Registrar.new(
              name:         name,
              url:          url,
              organization: org
          )
        end


        # In .jp domain, only one contact information is available, so default with registrant contact
        # co.jp gives different list of contacts.
        property_supported :registrant_contacts do

          city = ""
          address = ""
          country = ""

          if content_for_scanner =~ /\[Postal Address\]\s+((.+\n)+)\[/
            lines = $1.split("\n").map(&:strip)
            city    = lines[-4]
            address = lines[-3]
            country = lines[-2]
          end

          Record::Contact.new(
              :type => Record::Contact::TYPE_REGISTRANT,
              :name => content_for_scanner[/\[Name\]\s+(.+)\n/, 1],
              :email => content_for_scanner[/\[Email\]\s+(.+)\n/, 1],
              :zip => content_for_scanner[/\[Postal code\]\s+(.+)\n/, 1],
              :address => address,
              :city => city,
              :country => country
          )
        end

        # In co.jp domains, it gives a code for a link to the contact information.
        property_supported :admin_contacts do

          if content_for_scanner =~ /\[Administrative Contact\]\s+(.+)\n/
            # Here, given string as the code for admin contacts, you can set up a request
            # to the server as "CONTACT [code]", then it will return the information of
            # the admin contact.
            # You need to set the server identical to the current one, then pass in the code.
            # Note: The tests that test contacting the server again is located in 
            # spec/fixtures/responses/whois.jprs.jp/co.jp/property_state_registered.expected
            code = $1
            domain_lower = domain.to_s.downcase
            @server = Server.guess(domain_lower)
            adm_contact_content = @server.lookup("CONTACT " + code).to_s.gsub(/\r\n/, "\n")

            updated_on = ""
            if adm_contact_content =~ /\[Last Update\]\s+(.+)\n/
              Time.zone = "Asia/Tokyo"
              updated_on = Time.zone.parse($1)
            end
            Record::Contact.new(
                :type => Record::Contact::TYPE_ADMINISTRATIVE,
                :name => adm_contact_content[/\[Last\, First\](.+)\n/, 1].strip,
                :email => adm_contact_content[/\[E\-Mail\](.+)\n/, 1].strip,
                :organization => adm_contact_content[/\[Organization\](.+)\n/, 1].strip,
                :phone => adm_contact_content[/\[TEL\](.+)\n/, 1].strip,
                :fax => adm_contact_content[/\[FAX\](.+)\n/, 1].strip,
                :updated_on => updated_on

            )
          end
        end

        property_supported :technical_contacts do

          # Same information as above in admin_contacts, given a code for tech contacts you
          # send a request to the same server with the string "CONTACT [code]."
          if content_for_scanner =~ /\[Technical Contact\]\s+(.+)\n/
            code = $1
            domain_lower = domain.to_s.downcase
            @server = Server.guess(domain_lower)
            tech_contact_content = @server.lookup("CONTACT " + code).to_s.gsub(/\r\n/, "\n")

            updated_on = ""
            if tech_contact_content =~ /\[Last Update\]\s+(.+)\n/
              Time.zone = "Asia/Tokyo"
              updated_on = Time.zone.parse($1)
            end
            Record::Contact.new(
                :type => Record::Contact::TYPE_TECHNICAL,
                :name => tech_contact_content[/\[Last\, First\](.+)\n/, 1].strip,
                :email => tech_contact_content[/\[E\-Mail\](.+)\n/, 1].strip,
                :organization => tech_contact_content[/\[Organization\](.+)\n/, 1].strip,
                :phone => tech_contact_content[/\[TEL\](.+)\n/, 1].strip,
                :fax => tech_contact_content[/\[FAX\](.+)\n/, 1].strip,
                :updated_on => updated_on

            )
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No match!!/)
        end

        property_supported :registered? do
          !available?
        end

        #Timezone:
        # It prints the time in local timezone you set . 
        # For example:
        # $1 = 2000/11/17
        # Time.parse($1) --> 2000-11-17 00:00:00 -0700
        # Time.zone = "Asia/Tokyo"
        # Time.zone.parse($1) --> 2000-11-17 00:00:00 +0900
        property_supported :created_on do
          if content_for_scanner =~ /\[(?:Created on|Registered Date)\][ \t]+(.*)\n/
            Time.zone = "Asia/Tokyo"
            ($1.empty?) ? nil : Time.zone.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /\[Last Updated?\][ \t]+(.*)\n/
            Time.zone = "Asia/Tokyo"
            ($1.empty?) ? nil : Time.zone.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /\[Expires on\][ \t]+(.*)\n/
            Time.zone = "Asia/Tokyo"
            ($1.empty?) ? nil : Time.zone.parse($1)
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/\[Name Server\][\s\t]+([^\s\n]+?)\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name)
          end
        end


        # NEWPROPERTY
        def reserved?
          status == :reserved
        end

      end

    end
  end
end
