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
      # = whois.twnic.net.tw
      #
      # Parser for the whois.twnic.net.tw server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisTwnicNetTw < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner.strip == "No Found")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Record created on ([^ ]+) .+\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Record expires on ([^ ]+) .+\n/
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

		# The following methods are implemented by Yang Li on 01/28/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /Domain Name:\s+(.*)\n/i
        end
		
		property_not_supported :domain_id
		
        property_not_supported :registrar 
		
		property_not_supported :billing_contacts

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :technical_contacts do
          build_contact_1("Technical Contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :admin_contacts do
          build_contact_1("Administrative Contact", Whois::Record::Contact::TYPE_ADMIN)
        end
		
      private

        def build_contact(element, type)
          reg=Record::Contact.new(:type => type)
		  if content_for_scanner =~ /#{element}:\n((.+\n)+)\n/i
			  line_num=1
			  $1.split(%r{\n}).each do |line|
				reg["organization"]=line.strip if line_num==1
				reg["name"]=line.split(%r{\s{2,}})[1] if line_num==2
				reg["email"]=line.split(%r{\s{2,}})[2] if line_num==2
				reg["phone"]=line.strip if line_num==3
				reg["fax"]=line.strip if line_num==4
				reg["address"]=line.strip if line_num==5
				reg["city"]=line.strip if line_num==6
				reg["country_code"]=line.strip if line_num==7
				line_num=line_num+1
			  end			  
          end
		  return reg
        end	
		
        def build_contact_1(element, type)
          reg=Record::Contact.new(:type => type)
		  if content_for_scanner =~ /#{element}:\n((.+\n)+)\n/i
			  line_num=1
			  $1.split(%r{\n}).each do |line|
				reg["name"]=line.split(%r{\s{2,}})[1] if line_num==1
				reg["email"]=line.split(%r{\s{2,}})[2] if line_num==1
				reg["phone"]=line.strip if line_num==2
				reg["fax"]=line.strip if line_num==3
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
