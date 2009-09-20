#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client.
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


require 'whois/answer/parsers/base'


module Whois
  class Answer
    module Parsers

      #
      # = whois.publicinterestregistry.net parser
      #
      # Parser for the whois.publicinterestregistry.net server.
      #
      class WhoisPublicinterestregistryNet < Base

        def disclaimer
          node("Disclaimer")
        end


        def domain
          node("Domain Name") { |value| value.downcase }
        end

        def domain_id
          node("Domain ID")
        end


        def status
          node("Status")
        end

        def available?
          node("Domain ID").nil?
        end

        def registered?
          !available?
        end


        def created_on
          node("Created On") { |value| Time.parse(value) }
        end

        def updated_on
          node("Last Updated On") { |value| Time.parse(value) }
        end

        def expires_on
          node("Expiration Date") { |value| Time.parse(value) }
        end

        
        def registrar
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

        def registrant
          contact("Registrant")
        end

        def admin
          contact("Admin")
        end

        def technical
          contact("Tech")
        end


        def nameservers
          node("Name Server") { |server| server.reject { |value| value.empty? }.map { |value| value.downcase }}
        end


        def changed?(other)
          !unchanged?(other)
        end

        def unchanged?(other)
          self == other ||
          self.answer.to_s == other.answer.to_s
        end


        protected
        
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


          def ast
            @ast ||= parse
          end

          def node(key, &block)
            if block_given?
              value = ast[key]
              value = yield(value) unless value.nil?
              value
            else
              ast[key]
            end
          end

          def node?(key)
            !ast[key].nil?
          end

          def parse
            Scanner.new(answer.to_s).parse
          end


        class Scanner

          def initialize(content)
            @input = StringScanner.new(content.to_s)
          end

          def parse
            @ast = {}
            while !@input.eos?
              trim_newline  ||
              parse_content
            end
            @ast
          end
          
          private

            def parse_content
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