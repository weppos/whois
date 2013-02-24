#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
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
          if content_for_scanner =~ /Dominio:(.*)\n/
            $1.strip
          end
        end

        property_not_supported :domain_id


        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          domain.nil?
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Fecha de registro:(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Fecha de vencimiento:(.*)\n/
            Time.parse($1)
          end
        end


        property_not_supported :nameservers

      end

    end
  end
end
