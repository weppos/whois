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
require 'whois/answer/parser/scanners/afilias'


module Whois
  class Answer
    class Parser

      #
      # = whois.afilias.info parser
      #
      # Parser for the whois.afilias.info server.
      #
      class WhoisAfiliasInfo < Base
        include Features::Ast


        property_supported :disclaimer do
          node("property-disclaimer")
        end


        property_supported :domain do
          node("Domain Name", &:downcase)
        end

        property_supported :domain_id do
          node("Domain ID")
        end


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          node("Status") || []
        end

        property_supported :available? do
          !!node("status-available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Created On") do |value|
            Time.parse(value)
          end
        end

        property_supported :updated_on do
          node("Last Updated On") do |value|
            Time.parse(value)
          end
        end

        property_supported :expires_on do
          node("Expiration Date") do |value|
            Time.parse(value)
          end
        end


        property_supported :registrar do
          node("Sponsoring Registrar") do |value|
            value =~ /(.+?) \((.+?)\)/ || Whois.bug!("Unknown registrar format `#{value}'")
            Answer::Registrar.new(
              :id =>            $2,
              :name =>          $1,
              :organization =>  $1
            )
          end
        end

        property_supported :registrant_contact do
          contact("Registrant", Whois::Answer::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contact do
          contact("Admin", Whois::Answer::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contact do
          contact("Tech", Whois::Answer::Contact::TYPE_TECHNICAL)
        end



        property_supported :nameservers do
          node("Name Server") do |values|
            [*values].delete_if(&:empty?).map do |name|
              Nameserver.new(name.downcase)
            end
          end || []
        end


        # Initializes a new {Scanner} instance
        # passing the {Whois::Answer::Parser::Base#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::Afilias.new(content_for_scanner).parse
        end


        private

          def contact(element, type)
            node("#{element} ID") do
              address = (1..3).map { |i| node("#{element} Street#{i}") }.delete_if(&:empty?).join(" ")

              Answer::Contact.new(
                :type         => type,
                :id           => node("#{element} ID"),
                :name         => node("#{element} Name"),
                :organization => node("#{element} Organization"),
                :address      => address,
                :city         => node("#{element} City"),
                :zip          => node("#{element} Postal Code"),
                :state        => node("#{element} State/Province"),
                :country_code => node("#{element} Country"),
                :phone        => node("#{element} Phone"),
                :fax          => node("#{element} FAX"),
                :email        => node("#{element} Email")
              )
            end
          end

      end

    end
  end
end
