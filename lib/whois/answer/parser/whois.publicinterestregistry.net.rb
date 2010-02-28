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
          node("Disclaimer")
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
            Answer::Registrar.new(
              :id           => id,
              :name         => name
            )
          end
        end

        property_supported :registrant do
          contact("Registrant")
        end

        property_supported :admin do
          contact("Admin")
        end

        property_supported :technical do
          contact("Tech")
        end


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


        protected

          def parse
            Scanner.new(content_for_scanner).parse
          end

          def contact(element)
            node("#{element} ID") do |registrant_id|
              Answer::Contact.new(
                :id           => registrant_id,
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
              trim_newline      ||
              parse_not_found   ||
              parse_disclaimer  ||
              parse_pair        ||
              error("Unexpected token")
            end

            def trim_newline
              # The last line is \r\n\n
              @input.scan(/\n+/)
            end

            def parse_not_found
              @input.scan(/NOT FOUND\n/)
            end

            def parse_disclaimer
              if @input.match?(/NOTICE:/)
                lines = []
                while !@input.match?(/\n/) && @input.scan(/(.*)\n/)
                  lines << @input[1].strip
                end
                @ast["Disclaimer"] = lines.join(" ")
              else
                false
              end
            end

            def parse_pair
              if @input.scan(/(.*?):(.*?)\n/)
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

            def error(message)
              if @input.eos?
                raise "Unexpected end of input."
              else
                raise "#{message}: #{@input.peek(@input.string.length)}"
              end
            end

        end

      end
      
    end
  end
end