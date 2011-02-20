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
      # = whois.cnnic.cn parser
      #
      # Parser for the whois.cnnic.cn server.
      #
      class WhoisCnnicCn < Base
        include Ast

        property_not_supported :disclaimer


        property_supported :domain do
          node("Domain Name") { |value| value.downcase }
        end

        property_supported :domain_id do
          node("ROID")
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
          reserved? || !available?
        end


        property_supported :created_on do
          node("Registration Date") { |value| Time.parse(value) }
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          node("Expiration Date") { |value| Time.parse(value) }
        end

        property_supported :registrar do
          node("Sponsoring Registrar") do |value|
            Answer::Registrar.new(
              :id =>    value,
              :name =>  value
            )
          end
        end

        property_supported :registrant_contact do
          contact("Registrant", Whois::Answer::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contact do
          contact("Administrative", Whois::Answer::Contact::TYPE_ADMIN)
        end

        property_not_supported :technical_contact


        property_supported :nameservers do
          content_for_scanner.scan(/Name Server:(.+)\n/).flatten.map do |name|
            Answer::Nameserver.new(name.downcase)
          end
        end


        # NEWPROPERTY
        def reserved?
          !!node("status-reserved")
        end


        protected

          def parse
            Scanner.new(content_for_scanner).parse
          end

          def contact(element, type)
            n = node("#{element} Name")
            o = node("#{element} Organization")
            e = node("#{element} Email")
            return if n.nil? && o.nil? && e.nil?

            Answer::Contact.new(
              :type         => type,
              :name         => n,
              :organization => o,
              :email        => e
            )
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
                parse_reserved    ||
                parse_available   ||
                parse_pair        ||
                trim_newline      ||
                error("Unexpected token")
              end

              def trim_newline
                @input.scan(/\n/)
              end

              def parse_available
                if @input.scan(/^no matching record\n/)
                  @ast["status-available"] = true
                end
              end

              def parse_reserved
                if @input.scan(/^the domain you want to register is reserved\n/)
                  @ast["status-reserved"] = true
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
