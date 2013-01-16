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
      # = whois.sgnic.sg parser
      #
      # Parser for the whois.sgnic.sg server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisSgnicSg < Base

        property_supported :status do
          content_for_scanner.scan(/^\s+Domain Status:\s+(.+?)\n/).flatten
        end

        property_supported :available? do
          !!(content_for_scanner.strip == "Domain Not Found")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /^\s+Creation Date:\s+(.*)\n/
            Time.parse($1)
          end
        end

        # This method is modified by Yang on 01/15/2013
		property_supported :updated_on do
          if content_for_scanner =~ /^\s+Modified Date:\s+(.*)\n/
            Time.parse($1)
          end	
		end 

        property_supported :expires_on do
          if content_for_scanner =~ /^\s+Expiration Date:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :nameservers do
          if content_for_scanner =~ /Name Servers:\n((.+\n)+)\n/
            values = case value = $1.downcase
            # schema-1
            when /^(?:\s+([\w.-]+)\n){2,}/
              value.scan(/\s+([\w.-]+)\n/).map do |match|
                { :name => match[0] }
              end
            when /^(?:\s+([\w.-]+)\s+\((.+)\)\n){2,}/
              value.scan(/\s+([\w.-]+)\s+\((.+)\)\n/).map do |match|
                { :name => match[0], :ipv4 => match[1] }
              end
            # schema-2
            when /^(?:\s+([\w.-]+)){2,}/
              value.strip.split(/\s+/).map do |name|
                { :name => name }
              end
            else
              Whois.bug!(ParserError, "Unknown nameservers format `#{value}'")
            end

            values.map do |params|
              Record::Nameserver.new(params)
            end
          end
        end
		
		# The following methods are implemented by Yang on 1/15/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /Domain Name:\s+(.*)\s+\n/i
        end
		
		property_not_supported :domain_id
		
        property_supported :registrar do
          return $1 if content_for_scanner =~ /Registrar:\s+(.*)\s+\n/i
        end
		
        property_supported :admin_contacts do
          build_contact("Administrative Contact", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :registrant_contacts do
          build_contact("Registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :technical_contacts do
          build_contact("Technical Contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end
		
      private

        def build_contact(element, type)
          reg=Record::Contact.new(:type => type)
		  values=$1 if content_for_scanner =~ /#{element}:\n\s*\n((.+\n)+)\n/
		  values.scan(/^\s+(.+):\s*(.+)\s*\n/).map do |entry|
              reg["name"]=entry[1] if entry[0] =~ /Name/i
			  reg["email"]=entry[1] if entry[0]=~ /Email/i
          end
		  return reg
        end	
		# ----------------------------------------------------------------------------		

      end

    end
  end
end
