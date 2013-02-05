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
      # = whois.nic.ch parser
      #
      # Parser for the whois.nic.ch server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicCh < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /We do not have an entry/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        # Nameservers are listed in the following formats:
        #
        #   ns1.citrin.ch
        #   ns1.citrin.ch  [193.247.72.8]
        #
        property_supported :nameservers do
          if content_for_scanner =~ /Name servers:\n((.+\n)+)(?:\n|\z)/
            list  = {}
            order = []
            $1.split("\n").map do |line|
              if line =~ /(.+)\t\[(.+)\]/
                name, ip = $1, $2
                order << name unless order.include?(name)
                list[name] ||= Record::Nameserver.new(:name => name)
                list[name].ipv4 = ip if Whois::Server.valid_ipv4?(ip)
                list[name].ipv6 = ip if Whois::Server.valid_ipv6?(ip)
              else
                order << line unless order.include?(line)
                list[line] ||= Record::Nameserver.new(:name => line)
              end
            end
            order.map { |name| list[name] }
          end
        end
		
		# The following methods are implemented by Yang Li on 01/29/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
           return $1 if content_for_scanner =~ /Domain name:\n(.+\..+)\n/i
        end
		
		property_not_supported :domain_id

        property_not_supported :registrar 
		
		property_not_supported :admin_contacts

        property_supported :registrant_contacts do
          build_contact("Holder of domain name", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :technical_contacts do
          build_tech_contact("Technical Contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end

        property_not_supported :billing_contacts 
		
      private

        def build_contact(element, type)
          reg=Record::Contact.new(:type => type)
		  if content_for_scanner =~ /^(#{element}:\n(.+\n)+)\n/i
			  line_num=1
			  $1.split(%r{\n}).each do |line|
				reg["name"]=line.strip if line_num==3
				reg["organization"]=line.strip if line_num==2
				reg["address"]=line.strip if line_num==4
				reg["city"]=line.strip if line_num==5
				reg["country"]=line.strip if line_num==6
				line_num=line_num+1
			  end			  
          end
		  return reg
        end	
		
        def build_tech_contact(element, type)
          reg=Record::Contact.new(:type => type)
		  if content_for_scanner =~ /^(#{element}:\n(.+\n)+)\n/i
			  line_num=1
			  $1.split(%r{\n}).each do |line|
				reg["organization"]=line.strip if line_num==2
				reg["name"]=line.strip if line_num==3
				addrs=line.strip if line_num==4
				addrs="#{addrs}"+"\n"+line.strip if line_num==5
				reg["address"]=addrs if line_num==5	
				reg["city"]=line.strip if line_num==6
				reg["country"]=line.strip if line_num==7
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
