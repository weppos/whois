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

      # Parser for the whois.dk-hostmaster.dk server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @author Simone Carletti <weppos@weppos.net>
      # @author Mikkel Kristensen <mikkel@tdx.dk>
      #
      class WhoisDkHostmasterDk < Base

        property_supported :status do
          if content_for_scanner =~ /Status:\s+(.+?)\n/
            case $1.downcase
              when "active"
                :registered
              when "deactivated"
                :expired
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^No entries found for the selected source/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Registered:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Expires:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :nameservers do
          content_for_scanner.scan(/Hostname:\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name)
          end
        end

		# The following methods are implemented by Yang Li on 01/29/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /Domain:\s+(.+)\n/i
        end
		
		property_not_supported :domain_id
		
        property_not_supported :registrar 
		
		property_supported :admin_contacts do
          build_contact("Administrator", Whois::Record::Contact::TYPE_ADMIN)		
		end

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_not_supported :technical_contacts 

        property_not_supported :billing_contacts 
		
      private

        def build_contact(element, type)
          reg=Record::Contact.new(:type => type)
		  if content_for_scanner =~ /^#{element}\n((.+\n)+)\n/i			
			  $1.scan(/^(.+):\s+(.+)\n/).map do |entry|
				  reg["id"]=entry[1] if entry[0] =~ /Handle/i
				  reg["name"]=entry[1] if entry[0] =~ /Name/i
				  reg["organization"]=entry[1] if entry[0]=~ /Name/i
				  reg["address"]=entry[1] if entry[0]=~ /Address/i
				  reg["city"]= entry[1] if entry[0]=~ /City/i
				  reg["zip"]=entry[1] if entry[0]=~ /PostalCode/i
				  reg["country_code"]=entry[1] if entry[0]=~ /Country/i
				  reg["phone"]=entry[1] if entry[0]=~ /Phone/i
			  end
			end
		  return reg
        end	
		# ----------------------------------------------------------------------------

      end
    end
  end
end
