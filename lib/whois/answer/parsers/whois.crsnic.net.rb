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
      # = whois.crsnic.net.rb parser
      #
      # Parser for the whois.crsnic.net.rb server.
      #
      class WhoisCrsnicNet < Base

        def disclaimer
          node("Disclaimer")
        end


        def domain
          node("Domain Name") { |raw| raw.downcase }
        end

        def domain_id
          nil
        end


        def referral_whois
          node("Whois Server")
        end

        def referral_url
          node("Referral URL")
        end


        def status
          node("Status")
        end

        def available?
          node("Registrar").nil?
        end

        def registered?
          !available?
        end


        def created_on
          node("Creation Date") { |raw| Time.parse(raw) }
        end

        def updated_on
          node("Updated Date") { |raw| Time.parse(raw) }
        end

        def expires_on
          node("Expiration Date") { |raw| Time.parse(raw) }
        end


        def registrar
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
            Scanner.new(answer.parts.first.response).parse
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