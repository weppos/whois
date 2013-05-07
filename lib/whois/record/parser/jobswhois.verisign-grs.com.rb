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

      # Parser for the jobswhois.verisign-grs.com server.
      class JobswhoisVerisignGrsCom < Base
        include Scanners::Nodable

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
          node("Domain Status")
        end

        property_supported :available? do
          node("Sponsoring Registrar").nil?
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
                :id           => node("Sponsoring Registrar IANA ID"),
                :name         => value,
                :organization => value,
                :url          => referral_url
            )
          end
        end


        property_supported :nameservers do
          Array.wrap(node("Name Server")).reject { |value| value =~ /no nameserver/i }.map do |name|
            Nameserver.new(:name => name.downcase)
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