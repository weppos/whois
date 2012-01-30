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
          node("field:disclaimer") do |str|
            str.scan(/# (.+)\n/).flatten.map do |str|
              token = str.strip
              token.gsub!(/\s+/, " ")
            end.join(" ").gsub!(/(\s{2})/, "\n")
          end
        end


        property_supported :domain do
          node("field:domain")
        end

        property_not_supported :domain_id


        property_supported :status do
          if node?("status:available")
            :available
          else
            case node("field:status")
            when "ACTIVE"
              :registered
            else
              Whois.bug!(ParserError, "Unknown status `#{node("field:status")}'.")
            end
          end
        end

        property_supported :available? do
          status == :available
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("field:created") { |str| Time.parse(str) }
        end

        property_supported :updated_on do
          node("field:updated") { |str| Time.parse(str) }
        end

        property_supported :expires_on do
          node("field:expired") { |str| Time.parse(str) }
        end


        property_supported :registrar do
          node("field:registrar") { |hash| Registrar.new(*hash.values_at('nil', 'name', 'name', 'web')) }
        end

        property_supported :registrant_contacts do
          build_contact("field:registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("field:administrative_contact", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact("field:technical_contact", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          Array.wrap(node("field:nameservers")).map { |hash| Record::Nameserver.new(hash) }
        end

        # Also, there could be some DS records.


        # Initializes a new {Scanners::WhoisSmallregistryNet} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisSmallregistryNet.new(content_for_scanner).parse
        end


      private

        def build_contact(element, type)
          node(element) do |hash|
            c = Record::Contact.new(hash)
            c.type = type
            c.updated_on = Time.parse(c.updated_on)
            c
          end
        end

      end
    end
  end
end
