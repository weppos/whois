#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_afilias'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.xxx server.
      class WhoisNicXxx < BaseAfilias

        self.scanner = Scanners::BaseAfilias, {
            pattern_disclaimer: /^Access to/
        }


        property_supported :status do
          if reserved?
            :reserved
          else
            Array.wrap(node("Domain Status"))
          end
        end
        

        property_supported :created_on do
          node("Creation Date") do |value|
            Time.parse(value)
          end
        end

        property_supported :updated_on do
          node("Updated Date") do |value|
            Time.parse(value)
          end
        end

        property_supported :expires_on do
          node("Registry Expiry Date") do |value|
            Time.parse(value)
          end
        end


        # NEWPROPERTY
        def reserved?
          !!node("status:reserved")
        end

      end

    end
  end
end
