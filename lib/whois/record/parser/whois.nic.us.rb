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

      #
      # = whois.nic.us parser
      #
      # Parser for the whois.nic.us server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicUs < Base

        property_supported :status do
          content_for_scanner.scan(/Domain Status:\s+(.+?)\n/).flatten
        end

        property_supported :available? do
          !!(content_for_scanner =~ /Not found:/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Domain Registration Date:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Domain Last Updated Date:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Domain Expiration Date:\s+(.+?)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/Name Server:\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name.downcase)
          end
        end

		# The following methods are implemented by Yang Li on 01/24/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /Domain Name:\s+(.*)\n/i
        end
		
		property_supported :domain_id do
          return $1 if content_for_scanner =~ /Domain ID:\s+(.*)\n/i
        end
		
        property_supported :registrar do
          reg=Record::Registrar.new
		  content_for_scanner.scan(/^(.*Registrar.*):\s+(.+)\n/).map do |entry|
			reg["name"] = entry[1] if entry[0] =~ /Sponsoring Registrar$/i
			reg["organization"] = entry[1] if entry[0] =~ /Sponsoring Registrar$/i
			reg["url"] = entry[1] if entry[0] =~ /URL/i			
          end
		  return reg
        end

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Administrative Contact", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact("Technical Contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :billing_contacts do
          build_contact("Billing Contact", Whois::Record::Contact::TYPE_BILLING)
        end
		
      private

        def build_contact(element, type)
          reg=Record::Contact.new(:type => type)
		  content_for_scanner.scan(/^(#{element}.*):\s+(.+)\n/).map do |entry|
              reg["id"]=entry[1] if entry[0] =~ /#{element}\sID/i
              reg["name"]=entry[1] if entry[0] =~ /#{element}\sName/i
              reg["organization"]=entry[1] if entry[0]=~ /#{element}\sOrganization/i
              reg["address"]=entry[1] if entry[0]=~ /#{element}\sAddress1/i
              reg["city"]= entry[1] if entry[0]=~ /#{element}\sCity/i
              reg["zip"]=entry[1] if entry[0]=~ /#{element}\sPostal\sCode/i
              reg["state"]=entry[1] if entry[0]=~ /#{element}\sState\/Province/i
			  reg["country"]=entry[1] if entry[0]=~ /#{element}\sCountry$/i
              reg["country_code"]=entry[1] if entry[0]=~ /#{element}\sCountry\sCode/i
			  reg["phone"]=entry[1] if entry[0]=~ /#{element}\sPhone\sNumber/i
			  reg["fax"]=entry[1] if entry[0]=~ /#{element}\sFacsimile\sNumber/i
			  reg["email"]=entry[1] if entry[0]=~ /#{element}\sEmail/i
          end
		  return reg
        end	
		# ----------------------------------------------------------------------------
		
      end
    end
  end
end
