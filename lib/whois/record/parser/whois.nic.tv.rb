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

      # Parser for the whois.nic.tv server.
      class WhoisNicTv < Base
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
          # Return nil because when the response contains more than one registrar section
          # the response can be messy. See, for instance, the Verisign response for google.com.
          nil
        end


        property_supported :nameservers do
          Array.wrap(node("Name Server")).reject { |value| value =~ /no nameserver/i }.map do |name|
            Record::Nameserver.new(:name => name.downcase)
          end
        end


        def referral_whois
          node("Whois Server")
        end

        def referral_url
          node("Referral URL")
        end


        # Initializes a new {Scanners::Verisign} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::Verisign.new(content_for_scanner).parse
        end

      end

    end
  end
end
