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

      # Parser for the whois.domainregistry.my server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      class WhoisDomainregistryMy < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /Domain Name [^ ]+ does not exist in database/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /\[Record Created\]\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /\[Record Last Modified\]\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /\[Record Expired\]\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :nameservers do
          content_for_scanner.scan(/\[(?:Primary|Secondary) Name Server\](?:.+?)\n(.+\n)/).flatten.map do |line|
            name, ipv4 = line.strip.split(/\s+/)
            Record::Nameserver.new(:name => name, :ipv4 => ipv4)
          end
        end

		# The following methods are implemented by Yang Li on 02/05/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /Domain Name\]\s+(.*)\n/i
        end
		
		property_supported :domain_id do
          return $1 if content_for_scanner =~ /Registration No\.\]\s+(.*)\n/i
        end
		
        property_not_supported :registrar 
		
		property_supported :admin_contacts do
          build_contact("h", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :registrant_contacts do
          build_contact("g", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :technical_contacts do
          build_contact("j", Whois::Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :billing_contacts do
          build_contact("i", Whois::Record::Contact::TYPE_BILLING)
        end
		
      private

        def build_contact(element, type)
          reg=Record::Contact.new(:type => type)
		  if content_for_scanner =~ /^#{element}\s\[((.+\n)+)\n/i
			  line_num=0
			  $1.split(%r{\n}).each do |line|
				reg["name"]=line.strip if line_num==1
				reg["organization"]=line.strip if line_num==2
				reg["address"]=line.strip if line_num==3
				reg["city"]=line.strip if line_num==4
				reg["state"]=line.strip if line_num==5
				reg["country"]=line.strip if line_num==6
				reg["email"]=line.strip if line =~ /\w+\@\w+\.\w+/
				reg["phone"]=line.strip.split(' ')[1] if line =~ /\(Tel\)/i
				reg["fax"]=line.strip.split(' ')[1] if line =~ /\(Fax\)/i
				line_num=line_num+1
			  end			  
          end
		  return reg
        end	
		# ----------------------------------------------------------------------------
		
      end
    end
  end
end
