#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/verisign'


module Whois
  class Record
    class Parser

      class BaseVerisign < Base
        include Scanners::Scannable

        self.scanner = Scanners::Verisign


        property_supported :disclaimer do
          node("Disclaimer")
        end


        property_supported :domain do
          node("Domain Name", &:downcase)
        end

        property_supported :domain_id do
          node("Domain ID")
        end


        property_supported :status do
          # node("Status")
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^No match for/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Creation Date") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          node("Updated Date") { |value| Time.parse(value) }
        end

        property_supported :expires_on do
          node("Expiration Date") { |value| Time.parse(value) }
        end


        property_supported :registrar do
          node("Sponsoring Registrar") do |value|
            Whois::Record::Registrar.new(
                id:           last_useful_item(node("Sponsoring Registrar IANA ID")),
                name:         last_useful_item(value),
                url:          referral_url
            )
          end
        end


        property_supported :nameservers do
          Array.wrap(node("Name Server")).reject { |value| value =~ /no nameserver/i }.map do |name|
            Nameserver.new(name: name.downcase)
          end
        end


        def referral_whois
          node("Whois Server")
        end

        def referral_url
          last_useful_item(node("Referral URL"))
        end


        private

        # In case of "SPAM Response", the response contains more than one item
        # for the same value and the value becomes an Array.
        def last_useful_item(values)
          values.is_a?(Array) ? values.last : values
        end

      end

    end
  end
end
