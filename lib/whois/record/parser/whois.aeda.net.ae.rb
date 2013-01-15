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
      # = whois.aeda.net.ae parser
      #
      # Parser for the whois.aeda.net.ae server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisAedaNetAe < Base

        property_supported :status do
          if content_for_scanner =~ /Status:\s+(.+?)\n/
            case $1.downcase
              when "ok" then :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          content_for_scanner.strip == "No Data Found"
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :nameservers do
          content_for_scanner.scan(/Name Server:\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name)
          end
        end

		# The following methods are implemented by Yang Li on 12/19/2012
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /Domain Name:\s+(.*)\n/i
        end
		
		property_not_supported :domain_id
		
        property_supported :registrar do
          reg=Record::Registrar.new
		  content_for_scanner.scan(/^(Registrar.*):\s+(.+)\n/).map do |entry|
            reg["id"] = entry[1] if entry[0] =~ /Registrar\sID/i
			reg["name"] = entry[1] if entry[0] =~ /Registrar\sName$/i	
          end
		  return reg
        end

        property_supported :registrant_contacts do
          build_contact("Registrant Contact", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :technical_contacts do
          build_contact("Tech Contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end
		
      private

        def build_contact(element, type)
          reg=Record::Contact.new(:type => type)
		  content_for_scanner.scan(/^(#{element}.*):\s+(.+)\n/).map do |entry|
              reg["id"]=entry[1] if entry[0] =~ /#{element}\sID/i
              reg["name"]=entry[1] if entry[0] =~ /#{element}\sName/i
			  reg["email"]=entry[1] if entry[0]=~ /#{element}\sEmail/i
          end
		  return reg
        end	
		# ----------------------------------------------------------------------------		
		
      end
    end
  end
end
