#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
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
            parse_time($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Ultima Actualizacion: (.+?)\n/
            parse_time($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Fecha de Vencimiento: (.+?)\n/
            parse_time($1)
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

      end

    end
  end
end
