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
      # = whois.kenic.or.ke parser
      #
      # Parser for the whois.kenic.or.ke server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisKenicOrKe < Base

        property_supported :status do
          if content_for_scanner =~ /Status:\s+(.+?)\n/
            case $1.downcase
              when "active"
                :registered
              when "not registered"
                :available
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            Whois.bug!(ParserError, "Unable to parse status.")
          end
        end

        property_supported :available? do
          status == :available
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Modified:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expires:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :nameservers do
          if content_for_scanner =~ /Name Servers:\n((.+\n)+)\n/
            $1.split("\n").map do |name|
              Record::Nameserver.new(:name => name.strip)
            end
          end
        end

		# The following methods are implemented by Yang Li on 01/29/2013
		# ----------------------------------------------------------------------------
        property_not_supported :domain
		
		property_not_supported :domain_id
		
        property_supported :registrar do
          reg=Record::Registrar.new
		  content_for_scanner.scan(/^.*Registrar(.*):(.+)\n/).map do |entry|
			reg["name"] = entry[1].strip if entry[0] =~ /Name/i
			reg["organization"] = entry[1].strip if entry[0] =~ /Name/i	
          end
		  return reg
        end
		
		property_supported :admin_contacts do
          build_contact("Admin Contact", Whois::Record::Contact::TYPE_ADMIN)
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
		  if content_for_scanner =~ /\n\n#{element}:\n((.+\n)+)\n/i
			  con2=$1
			  con1=$1.split(%r{\n}).delete_if { |x| x !~ /(.+):(.+)/ }
			  addr=con2.split(%r{\n}).delete_if { |x| x =~ /(.+):(.+)/ }
			  con1.join("\n").scan(/(.+):(.+)\n/).map do |entry|
				reg["name"]=entry[1].strip if entry[0]=~/Name/i
				reg["organization"]=entry[1].strip if entry[0]=~/Organisation/i
				reg["email"]=entry[1].strip if entry[0]=~ /Email/i
				reg["phone"]=entry[1].strip if entry[0]=~ /Phone/i
			  end
			  line_num=1
			  addr.each do |line|
				reg["address"]=line.strip if line_num==2
				reg["city"]=line.strip if line_num==3
				reg["country"]=line.strip if line_num==4
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
