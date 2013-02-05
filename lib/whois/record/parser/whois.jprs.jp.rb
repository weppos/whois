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

      # Parser for the whois.jprs.jp server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisJprsJp < Base

        property_supported :status do
          if content_for_scanner =~ /\[Status\]\s+(.+)\n/
            case $1.downcase
            when "active"
              :registered
            when "reserved"
              :reserved
            when "to be suspended"
              :redemption
            when "suspended"
              :expired
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          elsif content_for_scanner =~ /\[State\]\s+(.+)\n/
            case $1.split(" ").first.downcase
            when "connected"
              :registered
            when "deleted"
              :suspended
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
         else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No match!!/)
        end

        property_supported :registered? do
          !available?
        end


        # TODO: timezone ('Asia/Tokyo')
        property_supported :created_on do
          if content_for_scanner =~ /\[(?:Created on|Registered Date)\][ \t]+(.*)\n/
            ($1.empty?) ? nil : Time.parse($1)
          end
        end

        # TODO: timezone ('Asia/Tokyo')
        property_supported :updated_on do
          if content_for_scanner =~ /\[Last Updated?\][ \t]+(.*)\n/
            ($1.empty?) ? nil : Time.parse($1)
          end
        end

        # TODO: timezone ('Asia/Tokyo')
        property_supported :expires_on do
          if content_for_scanner =~ /\[Expires on\][ \t]+(.*)\n/
            ($1.empty?) ? nil : Time.parse($1)
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/\[Name Server\][\s\t]+([^\s\n]+?)\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name)
          end
        end

		# The following methods are implemented by Yang Li on 01/28/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /Domain Name\]\s+(.*)\n/i
        end
		
		property_not_supported :domain_id
		
        property_not_supported :registrar 
		
		property_not_supported :admin_contacts

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_not_supported :technical_contacts 

        property_not_supported :billing_contacts 
		
      private

        def build_contact(element, type)
          reg=Record::Contact.new(:type => type)
		  reg["organization"]=$1.strip if content_for_scanner =~ /\[Registrant\](.*)\n/i
		  reg["name"] = $1.strip if content_for_scanner =~ /\[Name\](.*)\n/i
		  reg["url"] = $1.strip if content_for_scanner =~ /\[Web\sPage\](.*)\n/i
		  reg["email"] = $1.strip if content_for_scanner =~ /\[Email\](.*)\n/i
		  reg["zip"] = $1.strip if content_for_scanner =~ /\[Postal\scode\](.*)\n/i
		  reg["phone"] = $1.strip if content_for_scanner =~ /\[Phone\](.*)\n/i		  
		  reg["fax"] = $1.strip if content_for_scanner =~ /\[Fax\](.*)\n/i	
		  if content_for_scanner =~ /\[Postal\sAddress\](.*)\n((.+\n)+)\n/
			  reg["address"]=$1.strip
			  line_num=1
			  $2.split(%r{\n}).each do |line|
				reg["city"]=line.strip if line_num==1
				reg["state"]=line.strip if line_num==2
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
