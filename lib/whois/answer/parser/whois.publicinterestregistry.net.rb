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

        register_method :disclaimer do
          node("Disclaimer")
        end


        register_method :domain do
          node("Domain Name") { |value| value.downcase }
        end

        register_method :domain_id do
          node("Domain ID")
        end


        register_method :status do
          node("Status")
        end

        register_method :available? do
          node("Domain ID").nil?
        end

        register_method :registered? do
          !available?
        end


        register_method :created_on do
          node("Created On") { |value| Time.parse(value) }
        end

        register_method :updated_on do
          node("Last Updated On") { |value| Time.parse(value) }
        end

        register_method :expires_on do
          node("Expiration Date") { |value| Time.parse(value) }
        end

        
        register_method :registrar do
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

        register_method :registrant do
          contact("Registrant")
        end

        register_method :admin do
          contact("Admin")
        end

        register_method :technical do
          contact("Tech")
        end


        register_method :nameservers do
          node("Name Server") { |server| server.reject { |value| value.empty? }.map { |value| value.downcase }}
        end


        register_method :changed? do |other|
          !unchanged?(other)
        end

        register_method :unchanged? do |other|
          self == other ||
          self.content.to_s == other.content.to_s
        end


        protected

          def parse
            Scanner.new(content.to_s).parse
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
            @input = StringScanner.new(content.to_s)
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
              @input.scan(/\r\n+/)
            end

            def parse_not_found
              @input.scan(/NOT FOUND\n/)
            end

            def parse_disclaimer
              if @input.match?(/NOTICE:/)
                lines = []
                while !@input.match?(/\r\n/) && @input.scan(/(.*)\r\n/)
                  lines << @input[1].strip
                end
                @ast["Disclaimer"] = lines.join(" ")
              else
                false
              end
            end

            def parse_pair
              if @input.scan(/(.*?):(.*?)\r\n/)
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