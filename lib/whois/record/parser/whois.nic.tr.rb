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
      # = whois.nic.tr parser
      #
      # Parser for the whois.nic.tr server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicTr < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No match found for "(.+)"/)
        end

        property_supported :registered? do
          !available?
        end

        property_supported :created_on do
          if content_for_scanner =~ /Created on\.+:\s+(.+)\n/
            time = Time.parse($1)
            Time.utc(time.year, time.month, time.day)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Expires on\.+:\s+(.+)\n/
            time = Time.parse($1)
            Time.utc(time.year, time.month, time.day)
          end
        end
		
        property_supported :nameservers do
          if content_for_scanner =~ /Domain Servers:\n((.+\n)+)\n/
            $1.split("\n").map do |line|
              name, ipv4 = line.split(/\s+/)
              Record::Nameserver.new(:name => name, :ipv4 => ipv4)
            end
          end
        end

		# The following methods are implemented by Yang Li on 02/05/2013
		# ----------------------------------------------------------------------------
        property_not_supported :domain 
		
		property_not_supported :domain_id
		
        property_not_supported :registrar 
		
		property_supported :admin_contacts do
          build_contact("Administrative Contact", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :registrant_contacts do
          build_contact_1("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
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
		  if content_for_scanner =~ /#{element}:\n((.+\n)+)\n\n/i
			  $1.scan(/(.+):(.+)\n/).map do |entry|
				  reg["id"]=entry[1].strip if entry[0] =~ /NIC Handle/i
				  reg["name"]=entry[1].strip if entry[0] =~ /Name/i
				  reg["organization"]=entry[1].strip if entry[0]=~ /Organization/i
				  reg["address"]=entry[1].strip if entry[0]=~ /Address/i
				  reg["phone"]=entry[1].strip if entry[0]=~ /Phone/i
				  reg["fax"]=entry[1].strip if entry[0]=~ /Fax/i
			  end			  
          end
		  return reg
        end	
		
        def build_contact_1(element, type)
          reg=Record::Contact.new(:type => type)
		  if content_for_scanner =~ /#{element}:\n((.+\n)+)\n\n/i
			  line_num=1
			  $1.split(%r{\n}).each do |line|
				reg["name"]=line.strip if line_num==1
				reg["organization"]=line.strip if line_num==1
				reg["address"]=line.strip if line_num==2
				reg["city"]=line.strip if line_num==3
				reg["country"]=line.strip if line_num==5
				reg["email"]=line.strip if line=~ /\w+\@\w+\.\w+/
				reg["phone"]=line.strip if line_num==7
				reg["fax"]=line.strip if line_num==8
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
