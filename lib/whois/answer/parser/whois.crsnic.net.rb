#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'
require 'whois/answer/parser/scanners/verisign'


module Whois
  class Answer
    class Parser

      #
      # = whois.crsnic.net parser
      #
      # Parser for the whois.crsnic.net server.
      #
      class WhoisCrsnicNet < Base
        include Ast

        property_supported :disclaimer do
          node("Disclaimer")
        end


        property_supported :domain do
          node("Domain Name") { |raw| raw.downcase }
        end

        property_not_supported :domain_id



        property_supported :referral_whois do
          node("Whois Server")
        end

        property_supported :referral_url do
          @referral_url ||= node("Referral URL") do |raw|
            last_useful_item(raw)
          end
        end


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
          @registrar ||= node("Registrar") do |raw|
            Whois::Answer::Registrar.new(:name => last_useful_item(raw), :organization => last_useful_item(raw), :url => referral_url)
          end
        end


        property_supported :nameservers do
          @nameservers ||= node("Name Server") do |values|
            [*values].map do |value|
              value.downcase unless value =~ / /
            end.compact
          end
          @nameservers ||= []
        end


        protected

          def parse
            Scanners::Verisign.new(content_for_scanner).parse
          end

          # In case of "SPAM Response", the response contains more than one item
          # for the same value and the value becomes an Array.
          def last_useful_item(values)
            values.is_a?(Array) ? values.last : values
          end

      end

    end
  end
end