#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/verisign'


module Whois
  class Record
    class Parser

      # Parser for the whois.crsnic.net server.
      class WhoisCrsnicNet < Base
        include Scanners::Nodable

        property_supported :disclaimer do
          node("Disclaimer")
        end


        property_supported :domain do
          node("Domain Name") { |raw| raw.downcase }
        end

        property_not_supported :domain_id


        property_supported :status do
          node("Status")
        end

        property_supported :available? do
          node("Registrar").nil?
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Creation Date") { |raw| Time.parse(raw) }
        end

        property_supported :updated_on do
          node("Updated Date") { |raw| Time.parse(raw) }
        end

        property_supported :expires_on do
          node("Expiration Date") { |raw| Time.parse(raw) }
        end


        property_supported :registrar do
          node("Registrar") do |raw|
            Whois::Record::Registrar.new(
                :name         => last_useful_item(raw),
                :organization => last_useful_item(raw),
                :url          => referral_url
            )
          end
        end


        property_supported :nameservers do
          Array.wrap(node("Name Server")).reject { |value| value =~ / / }.map do |name|
            Record::Nameserver.new(:name => name.downcase)
          end
        end


        # Checks whether this response contains a message
        # that can be reconducted to a "WHOIS Server Unavailable" status.
        #
        # @return [Boolean]
        def response_unavailable?
          !!node("response:unavailable")
        end

        def referral_whois
          node("Whois Server")
        end

        def referral_url
          node("Referral URL") do |lines|
            last_useful_item(lines)
          end
        end


        # Initializes a new {Scanners::Verisign} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::Verisign.new(content_for_scanner).parse
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
