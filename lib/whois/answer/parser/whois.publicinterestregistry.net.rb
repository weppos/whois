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


module Whois
  class Answer
    class Parser

      #
      # = whois.publicinterestregistry.net parser
      #
      # Parser for the whois.publicinterestregistry.net server.
      #
      class WhoisPublicinterestregistryNet < Base
        include Ast

        property_supported :disclaimer do
          node("disclaimer")
        end


        property_supported :domain do
          node("Domain Name") { |value| value.downcase }
        end

        property_supported :domain_id do
          node("Domain ID")
        end


        property_supported :status do
          node("Status")
        end

        property_supported :available? do
          node("Domain ID").nil?
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Created On") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          node("Last Updated On") { |value| Time.parse(value) }
        end

        property_supported :expires_on do
          node("Expiration Date") { |value| Time.parse(value) }
        end


        property_supported :registrar do
          node("Sponsoring Registrar") do |registrar|
            id, name = if registrar =~ /(.*?)\((.*?)\)/
              [$2.strip, $1.strip]
            else
              [nil, registrar]
            end
            Whois::Answer::Registrar.new(
              :id   => id,
              :name => name
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
          node("Name Server") do |server|
            server.reject(&:empty?).map do |name|
              Answer::Nameserver.new(name.downcase)
            end
          end || []
        end


        # Checks whether the response has been throttled.
        #
        # @return [Boolean]
        #
        # @example
        #   WHOIS LIMIT EXCEEDED - SEE WWW.PIR.ORG/WHOIS FOR DETAILS
        #
        def throttled?
          !!node("response-throttled")
        end


        protected

          def parse
            Scanner.new(content_for_scanner).parse
          end

          def contact(element, type)
            node("#{element} ID") do |registrant_id|
              Whois::Answer::Contact.new(
                :id           => registrant_id,
                :type         => type,
                :name         => node("#{element} Name"),
                :organization => node("#{element} Organization"),
                :address      => [node("#{element} Street1"),
                                  node("#{element} Street2"),
                                  node("#{element} Street3")].reject { |value| value.to_s.empty? }.join(" "),
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


        class Scanner

          def initialize(content)
            @input = StringScanner.new(content)
          end

          def parse
            @ast = {}
            while !@input.eos?
              parse_content
            end
            @ast
          end

          private

            def parse_content
              parse_not_found   ||
              parse_throttled   ||
              parse_disclaimer  ||
              parse_pair        ||

              trim_empty_line   ||
              error("Unexpected token")
            end

            def trim_empty_line
              @input.skip(/^\n/)
            end

            def error(message)
              if @input.eos?
                raise "Unexpected end of input."
              else
                raise "#{message}: `#{@input.peek(@input.string.length)}'"
              end
            end


            def parse_not_found
              @input.skip(/^NOT FOUND\n/)
            end

            def parse_throttled
              if @input.match?(/^WHOIS LIMIT EXCEEDED/)
                @ast["response-throttled"] = true
                @input.skip(/^.+\n/)
              end
            end

            def parse_disclaimer
              if @input.match?(/^NOTICE:/)
                lines = []
                while !@input.match?(/\n/) && @input.scan(/(.*)\n/)
                  lines << @input[1].strip
                end
                @ast["disclaimer"] = lines.join(" ")
              else
                false
              end
            end

            def parse_pair
              if @input.scan(/(.+?):(.*?)\n/)
                key, value = @input[1].strip, @input[2].strip
                if @ast[key].nil?
                  @ast[key] = value
                else
                  @ast[key].is_a?(Array) || @ast[key] = [@ast[key]]
                  @ast[key] << value
                end
              else
                false
              end
            end

        end

      end

    end
  end
end