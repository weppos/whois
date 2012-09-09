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
      # = whois.coza.net.za parser
      #
      # Parser for the whois.coza.net.za server.
      #
      class WhoisCozaNetZa < Base

        property_not_supported :disclaimer


        property_not_supported :domain

        property_not_supported :domain_id


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
           content_for_scanner.strip == "Available"
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_not_supported :registrar

        property_not_supported :registrant_contacts

        property_not_supported :admin_contacts

        property_not_supported :technical_contacts


        property_not_supported :nameservers

      end

    end
  end
end
