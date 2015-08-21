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
      # = whois.registro.br parser
      #
      # Parser for the whois.registro.br server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisRegistroBr < Base

        # Time zone BRT is in its capital Brasilia
        Time.zone = "Brasilia"

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No match for domain/)
        end

        property_supported :registered? do
          !available?
        end

        property_supported :domain do
          if content_for_scanner =~ /domain:\s+(.+?)\n/
            $1
          end
        end

        # The website has an "owner" and "responsible", which seems to represent
        # organization name and contact name. FIXME if this is incorrect.
        property_supported :registrar do
          Record::Registrar.new(
              name: content_for_scanner[/responsible:\s+(.+?)\n/, 1],
              organization: content_for_scanner[/owner:\s+(.+?)\n/,1]
          )
        end


        property_supported :created_on do
          if content_for_scanner =~ /created:\s+(.+?)(\s+#.+)?\n/
            Time.zone.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /changed:\s+(.+?)\n/
            Time.zone.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /expires:\s+(.+?)\n/
            Time.zone.parse($1)
          end
        end

        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |line|
            name, ipv4 = line.strip.split(" ")
            Record::Nameserver.new(:name => name, :ipv4 => ipv4)
          end
        end

        # Added to parse disclaimers - .br domains have disclaimers split into
        # two, so I decided to put all into one paragraph separated with spaces.
        property_supported :disclaimer do
          rtn = ""
          content_for_scanner.scan(/%\s+(.+)\n/).flatten.map do |line|
            rtn += " " + line
          end
          rtn
        end

        #--
        # In .br domains, they give out an owner, admin, and technical code number
        # that matches a separate contact information in a separate paragraph of 
        # information. We ignore billing contact e.g :
        #
        # owner-c:     ASVBL
        # admin-c:     ASVBL
        # tech-c:      NAB51
        #
        # nic-hdl-br:  ASVBL
        # person:      Amazon Servicos de Varejo do Brasil LTDA
        # e-mail:      ccops@markmonitor.com
        # created:     20121119
        # changed:     20131105
        #
        # nic-hdl-br:  NAB51
        # person:      NameAction do Brasil
        # e-mail:      cctld@nameaction.com
        # created:     20020619
        # changed:     20140724
        #++
        property_supported :registrant_contacts do
          if content_for_scanner =~ /owner-c:(.+)\n/
            registrant_code = $1.strip
            if content_for_scanner =~ /nic-hdl-br:+\s+#{registrant_code}\s+((.+\n)+)\n/
              reg_contact_content = $1
              Record::Contact.new(
                :type => Record::Contact::TYPE_REGISTRANT,
                :name => reg_contact_content[/person:(.+)\n/, 1].strip,
                :email => reg_contact_content[/e-mail:(.+)\n/, 1].strip,
                :created_on => Time.zone.parse(reg_contact_content[/created:(.+)\n/, 1].strip),
                :updated_on => Time.zone.parse(reg_contact_content[/changed:(.+)\n/, 1].strip)
              )
            end 
          end
        end

        property_supported :admin_contacts do
          if content_for_scanner =~ /admin-c:(.+)\n/
            admin_code = $1.strip
            if content_for_scanner =~ /nic-hdl-br:+\s+#{admin_code}\s+((.+\n)+)\n/
              adm_contact_content = $1
              Record::Contact.new(
                :type => Record::Contact::TYPE_ADMINISTRATIVE,
                :name => adm_contact_content[/person:(.+)\n/, 1].strip,
                :email => adm_contact_content[/e-mail:(.+)\n/, 1].strip,
                :created_on => Time.zone.parse(adm_contact_content[/created:(.+)\n/, 1].strip),
                :updated_on => Time.zone.parse(adm_contact_content[/changed:(.+)\n/, 1].strip)
              )
            end 
          end
        end

        property_supported :technical_contacts do
          if content_for_scanner =~ /tech-c:(.+)\n/
            tech_code = $1.strip
            if content_for_scanner =~ /nic-hdl-br:+\s+#{tech_code}\s+((.+\n)+)\n/
              tech_contact_content = $1
              Record::Contact.new(
                :type => Record::Contact::TYPE_TECHNICAL,
                :name => tech_contact_content[/person:(.+)\n/, 1].strip,
                :email => tech_contact_content[/e-mail:(.+)\n/, 1].strip,
                :created_on => Time.zone.parse(tech_contact_content[/created:(.+)\n/, 1].strip),
                :updated_on => Time.zone.parse(tech_contact_content[/changed:(.+)\n/, 1].strip)
              )
            end 
          end
        end
      end

    end
  end
end
