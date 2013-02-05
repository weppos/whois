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
      # = whois.domain.kg
      #
      # Parser for the whois.domain.kg server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisDomainKg < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /This domain is available for registration/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Record created: (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Record last updated on (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Record expires on (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :nameservers do
          if content_for_scanner =~ /Name servers in the listed order:\n\n((.+\n)+)\n/
            $1.split("\n").map do |name|
              Record::Nameserver.new(:name => name.downcase)
            end
          end
        end

		# The following methods are implemented by Yang Li on 01/24/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /^Domain\s+(.*)\n/i
        end
		
		property_not_supported :domain_id
		
        property_supported :registrar do
          reg=Record::Registrar.new
		  content_for_scanner.scan(/^(.+):\s+(.+)\n/).map do |entry|
			reg["name"] = entry[1].strip if entry[0] =~ /Registrar/i
			reg["organization"] = entry[1].strip if entry[0] =~ /Registrar/i
			reg["url"] = entry[1].strip if entry[0] =~ /Referral URL/i			
          end
		  return reg
        end 
		
		property_supported :admin_contacts do
          build_contact("Administrative Contact", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :registrant_contacts do
          build_contact("Administrative Contact", Whois::Record::Contact::TYPE_REGISTRANT)
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
		  if content_for_scanner =~ /#{element}:\n((.+\n)+)\n/i
			  line_num=1
			  $1.split(%r{\n}).each do |line|
				reg["name"]=line.strip.split(',')[0].split('(')[0] if line_num==1
				reg["id"]=line.strip.split(',')[0].split('(')[1].gsub(/\)/,'') if line_num==1
				reg["organization"]=line.strip.split(',')[0] if line_num==1
				reg["email"]=line.strip.split(',')[1].strip if line_num==1
				reg["address"]=line.strip.split(',')[0] if line_num==2
				reg["city"]=line.strip.split(',')[1] if line_num==2
				reg["zip"]=line.strip.split(',')[2] if line_num==2
				reg["country"]=line.strip.split(',')[3] if line_num==2
				reg["phone"]=line.strip.split(':')[1] if line =~ /phone/i
				reg["fax"]=line.strip.split(':')[1] if line =~ /fax/i
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
