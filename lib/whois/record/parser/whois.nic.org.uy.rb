#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.org.uy server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicOrgUy < Base

        property_supported :status do
          if content_for_scanner =~ /Estatus del dominio: (.+?)\n/
            case $1.downcase
            when "activo"
              :registered
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
          if content_for_scanner =~ /Fecha de Creacion: (.+)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Ultima Actualizacion: (.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :expires_on


        property_supported :nameservers do
          if content_for_scanner =~ /Servidor\(es\) de Nombres de Dominio:\n\n((.+\n)+)\n/
            $1.scan(/-\s(.*?)\n/).flatten.map do |name|
              Record::Nameserver.new(:name => name)
            end
          end
        end

      end

    end
  end
end
