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
      # = whois.dns.lu parser
      #
      # Parser for the whois.dns.lu server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisDnsLu < Base

        property_supported :status do
          if content_for_scanner =~ /domaintype:\s+(.+)\n/
            case $1.downcase
              when "active" then :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /% No such domain/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /registered:\s+(.*)\n/
            # Force the parser to use the dd/mm/yyyy format.
            Time.utc(*$1.split("/").reverse)
          end
        end

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |line|
            if line =~ /(.+) \[(.+)\]/
              Record::Nameserver.new(:name => $1, :ipv4 => $2)
            else
              Record::Nameserver.new(:name => line)
            end
          end
        end

		# The following methods are implemented by Yang Li on 01/29/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /domainname:\s+(.*)\n/i
        end
		
		property_supported :domain_id do
          return $1 if content_for_scanner =~ /Domain ID:\s+(.*)\n/i
        end
		
        property_supported :registrar do
          reg=Record::Registrar.new
		  content_for_scanner.scan(/^registrar-(.*):\s+(.+)\n/).map do |entry|
			reg["name"] = entry[1] if entry[0] =~ /name/i
			reg["url"] = entry[1] if entry[0] =~ /url/i		
			reg["email"] = entry[1] if entry[0] =~ /email/i
			reg["country"] = entry[1] if entry[0] =~ /country/i				
          end
		  return reg
        end

        property_supported :registrant_contacts do
          build_contact("org", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("adm", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact("tec", Whois::Record::Contact::TYPE_TECHNICAL)
        end

        property_not_supported :billing_contacts 
		
      private

        def build_contact(element, type)
          reg=Record::Contact.new(:type => type)
		  content_for_scanner.scan(/^#{element}-(.*):\s+(.+)\n/).map do |entry|
              reg["name"]=entry[1] if entry[0] =~ /name/i
              reg["address"]=entry[1] if entry[0]=~ /address/i
              reg["city"]= entry[1] if entry[0]=~ /city/i
              reg["zip"]=entry[1] if entry[0]=~ /ZipCode/i
              reg["country_code"]=entry[1] if entry[0]=~ /country/i
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
