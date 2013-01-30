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

      # Parser for the whois.nic.at server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicAt < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /% nothing found/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          if content_for_scanner =~ /changed:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :expires_on


        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name)
          end
        end

		# The following methods are implemented by Yang Li on 01/29/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /domain:\s+(.*)\n/i
        end
		
		property_not_supported :domain_id
		
        property_not_supported :registrar 
		
		property_supported :admin_contacts do
          build_contact(1, Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :registrant_contacts do
          build_contact(0, Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :technical_contacts do
          build_contact(2, Whois::Record::Contact::TYPE_TECHNICAL)
        end

        property_not_supported :billing_contacts 
		
      private

        def build_contact(index, type)
          reg=Record::Contact.new(:type => type)
		  contacts=content_for_scanner.scan(/^personname:\s+\n((.+\n)+)\n/)
		  contacts[index].join.scan(/(.+):(.+)\n/).map do |entry|
              reg["id"]=entry[1].strip if entry[0] =~ /nic-hdl/i
              reg["name"]=entry[1].strip if entry[0] =~ /organization/i
              reg["organization"]=entry[1].strip if entry[0]=~ /organization/i
              reg["address"]=entry[1].strip if entry[0]=~ /street\saddress/i
              reg["city"]= entry[1].strip if entry[0]=~ /city/i
              reg["zip"]=entry[1].strip if entry[0]=~ /postal\scode/i
			  reg["country"]=entry[1].strip if entry[0]=~ /country/i
			  reg["phone"]=entry[1].strip if entry[0]=~ /phone/i
			  reg["fax"]=entry[1].strip if entry[0]=~ /fax\-no/i
			  reg["email"]=entry[1].strip if entry[0]=~ /e\-mail/i
          end
		  return reg
        end	
		# ----------------------------------------------------------------------------
      end
    end
  end
end
