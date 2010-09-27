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
      # = whois.registrypro.pro parser
      #
      # Parser for the whois.nic.bo server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicBo < Base

        property_supported :domain do
          @domain ||= if content_for_scanner =~ /Dominio:(.*)\n/
            $1.strip
          end
        end

        property_not_supported :domain_id


        property_supported :status do
          @status ||= if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          @available  ||= domain.nil?
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /Fecha de registro:(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /Fecha de vencimiento:(.*)\n/
            Time.parse($1)
          end
        end


        property_not_supported :nameservers

      end

    end
  end
end
