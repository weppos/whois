#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.fi.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.fi server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisFi < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisFi


        property_supported :disclaimer do
          node("field:disclaimer")
        end


        property_supported :domain do
          node("domain")
        end

        property_not_supported :domain_id


        property_supported :status do
          if registered?
            case node("status", &:downcase)
            when "granted"
              :registered
            when "grace period"
              :registered
            else
              Whois.bug!(ParserError, "Unknown status `#{node("status")}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("created") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          node("modified") { |value| Time.parse(value) }
        end

        property_supported :expires_on do
          node("expires") { |value| Time.parse(value) }
        end


        property_not_supported :registrar
        
        property_supported :registrant_contacts do
          node("descr") do |array|
            address = node("address")
            
            Record::Contact.new(
              type:         Record::Contact::TYPE_REGISTRANT,
              id:           array[1],
              name:         address[0],
              organization: array[0],
              address:      address[1],
              zip:          address[2],
              city:         address[3],
              phone:        node("phone")
            )
          end
        end

        property_not_supported :admin_contacts

        property_not_supported :technical_contacts


        property_supported :nameservers do
          Array.wrap(node("nserver")).map do |line|
            Record::Nameserver.new(name: line.split(" ").first)
          end
        end

      end

    end
  end
end
