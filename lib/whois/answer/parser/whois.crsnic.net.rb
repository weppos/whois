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
      # = whois.crsnic.net.rb parser
      #
      # Parser for the whois.crsnic.net.rb server.
      #
      class WhoisCrsnicNet < Base

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
            Scanner.new(content.to_s).parse
          end


        class Scanner

          def initialize(content)
            content = content.to_s.gsub("\r", "")
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
              parse_notice      ||
              parse_pair        ||
              trim_last_update  ||
              trim_fuffa        ||
              error("Unexpected token")
            end

            def trim_newline
              @input.scan(/\n/)
            end

            def trim_last_update
              @input.scan(/>>>(.*?)<<<\n/)
            end

            def trim_fuffa
              @input.scan(/^\w(.*)\n/) ||
              (@input.scan(/^\w(.*)/) and @input.eos?)
            end

            def parse_not_found
              if @input.scan(/No match for "(.*?)"\.\n/)
                @ast["Domain Name"] = @input[1].strip
              end
            end

            # NOTE: parse_notice and parse_disclaimer are similar!
            def parse_notice
              if @input.match?(/NOTICE:/)
                lines = []
                while !@input.match?(/\n/) && @input.scan(/(.*)\n/)
                  lines << @input[1].strip
                end
                @ast["Notice"] = lines.join(" ")
              else
                false
              end
            end

            def parse_disclaimer
              if @input.match?(/TERMS OF USE:/)
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
              if @input.scan(/\s+(.*?):(.*?)\n/)
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
              raise "#{message}: #{@input.peek(@input.string.length)}"
            end

        end


      end

    end
  end
end