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
      # = whois.nic.cc parser
      #
      # Parser for the whois.nic.cc server.
      #
      class WhoisNicCc < Base
        include Ast

        property_supported :disclaimer do
          @disclaimer ||= node("Disclaimer")
        end


        property_supported :domain do
          @domain||= node("Domain Name") { |raw| raw.downcase }
        end

        property_not_supported :domain_id


        property_supported :referral_whois do
          @referral_whois ||= node("Whois Server")
        end

        property_supported :referral_url do
          @referral_url ||= node("Referral URL")
        end


        property_supported :status do
          @status ||= node("Status")
        end

        property_supported :available? do
          @available  ||= node("Registrar").nil?
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_supported :created_on do
          @created_on ||= node("Creation Date") { |raw| Time.parse(raw) }
        end

        property_supported :updated_on do
          @updated_on ||= node("Updated Date") { |raw| Time.parse(raw) }
        end

        property_supported :expires_on do
          @expires_on ||= node("Expiration Date") { |raw| Time.parse(raw) }
        end


        property_supported :registrar do
          # Return nil because when the response contains more than one registrar section
          # the response can be messy. See, for instance, the Verisign response for google.com.
          nil
        end


        property_supported :nameservers do
          @nameservers ||= node("Name Server") { |values| [*values].map(&:downcase) }
          @nameservers ||= []
        end


        protected

          def parse
            Scanners::Verisign.new(content_for_scanner).parse
          end

      end

    end
  end
end
