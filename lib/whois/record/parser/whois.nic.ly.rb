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
      # = whois.nic.ly parser
      #
      # Parser for the whois.nic.ly server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicLy < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          (content_for_scanner.strip == "Not found")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Updated:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expired:\s+(.*)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Domain servers in listed order:\n((.+\n)+)\n/
            $1.split("\n").map do |name|
              Record::Nameserver.new(:name => name.strip)
            end
          end
        end

		# The following methods are implemented by Yang Li on 01/24/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1.strip if content_for_scanner =~ /Domain Name:\s+(.*)\n/i
        end
		
		property_not_supported :domain_id
		
        property_not_supported :registrar 
		
		property_supported :admin_contacts do
          build_contact("Administrative Contact", Whois::Record::Contact::TYPE_REGISTRANT)
        end
		
        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
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
		  if content_for_scanner =~ /^#{element}:\n((.+\n)+)\n/i
			  line_num=1
			  $1.split(%r{\n}).each do |line|
				reg["name"]=line.strip if line_num==1
				reg["organization"]=line.strip if line_num==2
				reg["address"]=line.strip if line_num==3
				reg["city"]=line.strip if line_num==4
				reg["state"]=line.strip if line_num==5
				reg["country"]=line.strip if line_num==6
				reg["zip"]=line.strip.split(':').last if line_num==7
				reg["phone"]=line.strip.split(':').last if line_num==8
				reg["fax"]=line.strip.split(':').last if line_num==9				
				reg["email"]=line.strip if line_num==10
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
