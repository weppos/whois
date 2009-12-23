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
      # = jobswhois.verisign-grs.com parser
      #
      # Parser for the jobswhois.verisign-grs.com server.
      #
      class JobswhoisVerisignGrsCom < Base
        include Ast

        register_method :disclaimer do
          node("Disclaimer")
        end


        register_method :domain do
          node("Domain Name") { |raw| raw.downcase }
        end

        register_method :domain_id do
          nil
        end


        register_method :referral_whois do
          node("Whois Server")
        end

        register_method :referral_url do
          node("Referral URL")
        end


        register_method :status do
          node("Status")
        end

        register_method :available? do
          node("Registrar").nil?
        end

        register_method :registered? do
          !available?
        end


        register_method :created_on do
          node("Creation Date") { |raw| Time.parse(raw) }
        end

        register_method :updated_on do
          node("Updated Date") { |raw| Time.parse(raw) }
        end

        register_method :expires_on do
          node("Expiration Date") { |raw| Time.parse(raw) }
        end


        register_method :registrar do
          # Return nil because when the response contains more than one registrar section
          # the response can be messy. See, for instance, the Verisign response for google.com.
          nil
        end


        protected

          def parse
            Scanners::VerisignScanner.new(content.to_s).parse
          end

      end

    end
  end
end