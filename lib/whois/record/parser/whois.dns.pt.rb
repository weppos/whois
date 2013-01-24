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

      # Parser for the whois.dns.pt server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisDnsPt < Base

        property_supported :status do
          if content_for_scanner =~ /^Estado \/ Status:\s+(.+)\n/
            case $1.downcase
              when "active"   then :registered
              when "reserved" then :reserved
              when "tech-pro" then :inactive
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^.* no match$/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ / Creation Date .+?:\s+(.+)\n/
            Time.utc(*$1.split("/").reverse)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ / Expiration Date .+?:\s+(.+)\n/
            Time.utc(*$1.split("/").reverse)
          end
        end

        property_supported :nameservers do
          content_for_scanner.scan(/Nameserver:\s(?:.+\t)?(.+?)\.\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name)
          end
        end
		
		# The following methods are implemented by Yang Li on 01/24/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /Domain Name:\s+(.*)\n/i
        end
		
		property_not_supported :domain_id
		
        property_not_supported :registrar 
		
		property_not_supported :admin_contacts

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :technical_contacts do
          build_contact("Tech Contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :billing_contacts do
          build_contact("Billing Contact", Whois::Record::Contact::TYPE_BILLING)
        end
		
      private

        def build_contact(element, type)
          reg=Record::Contact.new(:type => type)
		  if content_for_scanner.gsub(/\//,'') =~ /(.+#{element}\n(.+\n)+)\n/i
			  line_num=1
			  $1.split(%r{\n}).each do |line|
				reg["name"]=line.strip if line_num==2
				reg["organization"]=line.strip if line_num==2
				reg["address"]=line.strip if line_num==3
				reg["city"]=line.strip if line_num==4
				reg["zip"]=line.strip if line_num==5
				entry=line.split(':')
				reg["email"]=entry[1].strip if entry[0]=~ /Email/i
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
