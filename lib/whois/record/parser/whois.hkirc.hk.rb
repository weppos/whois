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

      # Parser for the whois.hkirc.hk server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisHkircHk < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          content_for_scanner.strip == 'Domain Not Found'
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Domain Name Commencement Date:\s(.+?)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Expiry Date:\s(.+?)\n/
            time = $1.strip
            Time.parse(time) unless time == 'null'
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Name Servers Information:\n\n((.+\n)+)\n/
            $1.split("\n").map do |name|
              Record::Nameserver.new(:name => name.strip.downcase)
            end
          end
        end

		# The following methods are implemented by Yang Li on 01/23/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /Domain Name:\s+(.*)\n/i
        end
		
		property_not_supported :domain_id
		
        property_supported :registrar do
          reg=Record::Registrar.new
		  content_for_scanner.scan(/^(Registrar.*?):\s+(.+)\n/).map do |entry|
			reg["name"] = entry[1] if entry[0] =~ /Registrar\sName$/i	
			reg["url"] = entry[1] if entry[0] =~ /Registrar\sContact/i
          end
		  return reg
        end

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("Administrative", Whois::Record::Contact::TYPE_ADMIN)
        end
		
        property_supported :technical_contacts do
          build_contact("Technical", Whois::Record::Contact::TYPE_TECHNICAL)
        end
		
      private

        def build_contact(element,type)
          reg=Record::Contact.new(:type => type)
		  if content_for_scanner.gsub(/(\(|\)|\/)/,' ') =~ /^(#{element}\sContact\sInformation\:\n\n((.+\n)+)\n\n\n)/i
		  #if content_for_scanner.sub(%r{(\(|\|\/)},'') =~ /^(#{element}\sContact\sInformation((.*\n)+)(\n\n\n\n)?)/i
				values=$1 
			    values.scan(/^(.+):\s*(.+)\s*\n/).map do |entry|	
				  reg["name"]=entry[1] if entry[0] =~ /Company\s(|English\s)Name/i
				  reg["email"]=entry[1] if entry[0]=~ /Email/i
				  reg["address"]=entry[1] if entry[0]=~ /Address/i
				  reg["country_code"]=entry[1] if entry[0]=~ /Country/i
				  reg["phone"]=entry[1] if entry[0]=~ /Phone/i
				  reg["fax"]=entry[1] if entry[0]=~ /Fax/i
				end
		  end
		  return reg
        end	
		
		# ----------------------------------------------------------------------------		
		
      end
    end
  end
end
