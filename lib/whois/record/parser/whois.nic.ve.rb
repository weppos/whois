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
      # = whois.nic.ve parser
      #
      # Parser for the whois.nic.ve server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicVe < Base

        property_supported :status do
          if content_for_scanner =~ /Estatus del dominio: (.+?)\n/
            case $1.downcase
              when "activo"
                :registered
              when "suspendido"
                :inactive
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No match for "(.+?)"/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Fecha de Creacion: (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Ultima Actualizacion: (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Fecha de Vencimiento: (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :nameservers do
          if content_for_scanner =~ /Servidor\(es\) de Nombres de Dominio:\n\n((.+\n)+)\n/
            $1.scan(/-\s(.*?)\n/).flatten.map do |name|
              Record::Nameserver.new(:name => name)
            end
          end
        end

        # NEWPROPERTY
        # def suspended?
        # end
		
		# The following methods are implemented by Yang Li on 01/29/2013
		# ----------------------------------------------------------------------------
        property_supported :domain do
          return $1 if content_for_scanner =~ /Nombre de Dominio:\s+(.*)\n/i
        end
		
		property_not_supported :domain_id
		
        property_not_supported :registrar 
		
		property_supported :admin_contacts do
          build_contact("Contacto Administrativo", Whois::Record::Contact::TYPE_ADMIN)
        end
		
        property_supported :registrant_contacts do
          build_contact("Titular", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :technical_contacts do
          build_contact("Contacto Tecnico", Whois::Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :billing_contacts do
          build_contact("Contacto de Cobranza", Whois::Record::Contact::TYPE_BILLING)
        end
		
      private

        def build_contact(element, type)
          reg=Record::Contact.new(:type => type)
		  if content_for_scanner =~ /#{element}:\s*\n((.+\n)+)\n/i
			  line_num=1
			  $1.split(%r{\n}).each do |line| 
				titles=line.strip if line_num==1
				reg["name"]=line.strip.split(%r{\t+}).first if line_num==1
				reg["email"]=line.strip.split(%r{\t+}).last if line_num==1
				reg["organization"]=line.strip if line_num==2
				reg["address"]=line.strip if line_num==3
				reg["city"]=line.strip if line_num==4
				reg["phone"]=line.strip.split(%r{\s+}).first if line_num==5
				reg["fax"]=line.split(%r{\s+}).last if line_num==5
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
