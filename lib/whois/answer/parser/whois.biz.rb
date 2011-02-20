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
require 'whois/answer/parser/scanners/whoisbiz'


module Whois
  class Answer
    class Parser

      #
      # = whois.biz parser
      #
      # Parser for the whois.biz server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisBiz < Base
        include Features::Ast

        # Actually the :disclaimer is supported,
        # but extracting it with the current scanner
        # would require too much effort.
        # property_supported :disclaimer


        property_supported :domain do
          node("Domain Name") { |value| value.downcase }
        end

        property_supported :domain_id do
          node("Domain ID")
        end


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          node("Domain Status")
        end

        property_supported :available? do
          !!node("status-available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Domain Registration Date") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          node("Domain Last Updated Date") { |value| Time.parse(value) }
        end

        property_supported :expires_on do
          node("Domain Expiration Date") { |value| Time.parse(value) }
        end


        property_supported :registrar do
          node("Sponsoring Registrar") do |raw|
            Answer::Registrar.new(
              :id           => node("Sponsoring Registrar IANA ID"),
              :name         => node("Sponsoring Registrar")
            )
          end
        end


        property_supported :registrant_contact do
          contact("Registrant", Whois::Answer::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contact do
          contact("Administrative Contact", Whois::Answer::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contact do
          contact("Technical Contact", Whois::Answer::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          node("Name Server") do |values|
            [*values].map do |name|
              Nameserver.new(name.downcase)
            end
          end || []
        end


        # Initializes a new {Scanners::Verisign} instance
        # passing the {Whois::Answer::Parser::Base#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::Whoisbiz.new(content_for_scanner).parse
        end


        protected

          def contact(element, type)
            node("#{element} ID") do |raw|
              Answer::Contact.new(
                :type         => type,
                :id           => node("#{element} ID"),
                :name         => node("#{element} Name"),
                :organization => node("#{element} Organization"),
                :address      => node("#{element} Address1"),
                :city         => node("#{element} City"),
                :zip          => node("#{element} Postal Code"),
                :state        => node("#{element} State/Province"),
                :country      => node("#{element} Country"),
                :country_code => node("#{element} Country Code"),
                :phone        => node("#{element} Phone Number"),
                :fax          => node("#{element} Facsimile Number"),
                :email        => node("#{element} Email")
              )
            end
          end

      end

    end
  end
end
