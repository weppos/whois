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
      # = whois.ai parser
      #
      # Parser for the whois.ai server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisAi < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /Domain (.+?) not registred/)
        end

        property_supported :registered? do
          !available?
        end

        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on

        property_supported :nameservers do
          if content_for_scanner =~ /Nameservers\n((.+\n)+)\n/
            $1.split("\n").select { |e| e =~ /Server Hostname/ }.map do |line|
              Record::Nameserver.new(:name => line.split(":").last.strip)
            end
          end
        end
		
		# The following methods are implemented by Yang Li on 02/04/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $2.strip if content_for_scanner =~ /Complete Domain Name(.*):(.*)\n/i
        end
		
		property_not_supported :domain_id
		
        property_not_supported :registrar 
		
		property_supported :admin_contacts do
          build_contact("Administrative Contact", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :registrant_contacts do
          build_contact("Organization Using Domain Name", Whois::Record::Contact::TYPE_REGISTRANT)
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
		  if content_for_scanner =~ /#{element}\n((^\s.+\n)+)/i 
		    $1.scan(/^(.+):(.+)\n/).map do |entry|
              reg["id"]=entry[1].strip if entry[0] =~ /NIC Handle/i
              reg["name"]=entry[1].strip if entry[0] =~ /Name \(Last\, First\)/i
              reg["organization"]=entry[1].strip if entry[0]=~ /Organization Name/i
              reg["address"]=entry[1].strip if entry[0]=~ /Street Address/i
              reg["city"]= entry[1].strip if entry[0]=~ /City/i
              reg["zip"]=entry[1].strip if entry[0]=~ /Postal Code/i
              reg["state"]=entry[1].strip if entry[0]=~ /State/i
			  reg["country"]=entry[1].strip if entry[0]=~ /Country/i
			  reg["phone"]=entry[1].strip if entry[0]=~ /Phone\sNumber/i
			  reg["fax"]=entry[1].strip if entry[0]=~ /Fax\sNumber/i
			  reg["email"]=entry[1].strip if entry[0]=~ /E-Mailbox/i	
			end
          end
		  return reg
        end	
		# ----------------------------------------------------------------------------
		
      end
    end
  end
end
