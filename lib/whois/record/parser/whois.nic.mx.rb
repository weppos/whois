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
      # = whois.nic.mx parser
      #
      # Parser for the whois.nic.mx server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicMx < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /Object_Not_Found/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created On:\s+(.*)\n/
            Time.parse($1)
          end
        end

        # FIXME: the response contains localized data
        # Expiration Date: 10-may-2011
        # Last Updated On: 15-abr-2010 <--
        # property_supported :updated_on do
        #   if content_for_scanner =~ /Last Updated On:\s+(.*)\n/
        #     Time.parse($1)
        #   end
        # end

        property_supported :expires_on do
          if content_for_scanner =~ /Expiration Date:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :nameservers do
          if content_for_scanner =~ /Name Servers:\n((.+\n)+)\n/
            $1.scan(/DNS:\s+(.+)\n/).flatten.map do |line|
              name, ipv4 = line.strip.split(/\s+/)
              Record::Nameserver.new(:name => name, :ipv4 => ipv4)
            end
          end
        end

		# The following methods are implemented by Yang Li on 02/05/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /Domain Name:\s+(.*)\n/i
        end
		
		property_not_supported :domain_id
		
        property_not_supported :registrar 
		
		property_supported :admin_contacts do
          build_contact("Administrative Contact", Whois::Record::Contact::TYPE_ADMIN)
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
			  $1.scan(/^(.+):(.+)\n/).map do |entry|
				  reg["name"]=entry[1].strip if entry[0] =~ /Name/i
				  reg["organization"]=entry[1].strip if entry[0]=~ /Name/i
				  reg["city"]= entry[1].strip if entry[0]=~ /City/i
				  reg["state"]=entry[1].strip if entry[0]=~ /State/i
				  reg["country"]=entry[1].strip if entry[0]=~ /Country/i
			  end
          end
		  return reg
        end	
		# ----------------------------------------------------------------------------
		
      end
    end
  end
end
