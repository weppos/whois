#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'


module Whois
  class Answer
    class Parser

      #
      # = whois.nic.ec parser
      #
      # Parser for the whois.nic.ec server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicEc < Base

        property_supported :status do
          @status ||= if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          @available ||= !!(content_for_scanner =~ /Domain not registered/)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /^Fecha de Creacion:(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /^Ultima Modificacion:(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /^Fecha de Expiracion:(.*)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= if content_for_scanner =~ /Servidores de dominio \(Name Servers\)\n((.+\n)+)\n/
            $1.split("\n")
          else
            []
          end
        end

      end

    end
  end
end
