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
          @disclaimer ||= node("disclaimer")
        end


        property_supported :domain do
          @domain ||= node("Domain Name") { |value| value.downcase }
        end

        property_supported :domain_id do
          @domain_id ||= node("Domain ID")
        end


        property_supported :status do
          @status ||= node("Status")
        end

        property_supported :available? do
          node("Domain ID").nil?
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          @created_on ||= node("Created On") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          @updated_on ||= node("Last Updated On") { |value| Time.parse(value) }
        end

        property_supported :expires_on do
          @expires_on ||= node("Expiration Date") { |value| Time.parse(value) }
        end


        property_supported :registrar do
          @registrar ||= node("Sponsoring Registrar") do |registrar|
            id, name = if registrar =~ /(.*?)\((.*?)\)/
              [$2.strip, $1.strip]
            else
              [nil, registrar]
            end
            Whois::Answer::Registrar.new(
              :id           => id,
              :name         => name
            )
          end
        end

        property_supported :registrant_contact do
          @registrant_contact ||= contact("Registrant", Whois::Answer::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contact do
          @admin_contact ||= contact("Admin", Whois::Answer::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contact do
          @technical_contact ||= contact("Tech", Whois::Answer::Contact::TYPE_TECHNICAL)
        end

        # @deprecated
        register_property :registrant, :supported
        # @deprecated
        register_property :admin, :supported
        # @deprecated
        register_property :technical, :supported


        property_supported :nameservers do
          @nameservers ||= node("Name Server") { |server| server.reject(&:empty?).map(&:downcase) }
          @nameservers ||= []
        end


        property_supported :changed? do |other|
          !unchanged?(other)
        end

        property_supported :unchanged? do |other|
          self == other ||
          self.content.to_s == other.content.to_s
        end

        def throttle?
          !!node("status-throttle")
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
              parse_throttle    ||
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

            def parse_throttle
              if @input.match?(/^WHOIS LIMIT EXCEEDED/)
                @ast["status-throttle"] = true
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