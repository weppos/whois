#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/parser/scanners/whois.smallregistry.net.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.smallregistry.net server.
      #
      # @author Mathieu Arnold <m@absolight.fr>
      #
      class WhoisSmallregistryNet < Base
        include Scanners::Ast

        property_supported :disclaimer do
          node("field:disclaimer")
        end


        property_supported :domain do
          node("field:domain")
        end

        property_not_supported :domain_id


        property_supported :status do
          if node?("status:not_found")
            :available
          elsif node?("field:status")
            node("field:status").to_sym
          else
            :unknown
          end
        end

        property_supported :available? do
          status == :available
        end

        property_supported :registered? do
          !available?
        end

        property_supported :created_on do
          node("field:created")
        end

        property_supported :updated_on do
          node("field:updated")
        end

        property_supported :expires_on do
          node("field:expired")
        end

        property_supported :registrar do
          if node?("registrar")
            Registrar.new(*node("registrar").values_at('nil', 'name', 'name', 'web'))
          end
        end

        property_supported :registrant_contacts do
          build_contact(node("contact:registrant"))
        end

        property_supported :admin_contacts do
          build_contact(node("contact:administrative_contact"))
        end

        property_supported :technical_contacts do
          build_contact(node("contact:technical_contact"))
        end

        # Seems nobody cares about that.
        # property_supported :billing_contacts do
        #   node("contact:billing_contact")
        # end

        property_supported :nameservers do
          Array.wrap(node("nameservers")).map { |hash| Record::Nameserver.new(hash) }
        end

        # Also, there could be some DS records.

        def parse
          Scanners::WhoisSmallregistryNet.new(content_for_scanner).parse
        end

        def build_contact(hash)
          if !hash.nil?
            Contact.new(hash)
          end
        end

      end
    end
  end
end
