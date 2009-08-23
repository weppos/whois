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


require 'whois/response/parsers/base'


module Whois
  class Response
    module Parsers
      
      class WhoisNicIt < Base

        def disclaimer
          node("Disclaimer")
        end

        def status
          node("Status").downcase.to_sym
        end
        
        def available?
          node("Status") == "AVAILABLE"
        end
        
        def registered?
          !available?
        end
        
        
        def created_on
          return unless registered?
          node("Created") { |value| Time.parse(value) }
        end
        
        def updated_on
          return unless registered?
          node("Last Update") { |value| Time.parse(value) }
        end
        
        def expires_on
          return unless registered?
          node("Expire Date") { |value| Time.parse(value) }
        end


        def parse
          @input = StringScanner.new(@response.to_s)
          @ast = {}
          while !@input.eos?
            trim_newline  ||
            parse_content
          end
          @ast
        end

        def ast
          @ast || parse
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


        private

          def parse_content
            parse_disclaimer  ||
            parse_pair        ||
            parse_section     ||
            error("Unexpected token")
          end

          def trim_newline
            @input.scan(/\n/)
          end

          def parse_pair
            if @input.scan(/(.*?):(.*?)\n/)
              key, value = @input[1].strip, @input[2].strip
              @ast[key] = value
            else
              false
            end
          end

          def parse_disclaimer
            if @input.match?(/\*(.*?)\*\n/)
              disclaimer = []
              while @input.scan(/\*(.*?)\*\n/)
                matched = @input[1].strip
                disclaimer << matched if matched =~ /\w+/
              end
              @ast["Disclaimer"] = disclaimer.join(" ")
            else
              false
            end
          end

          def parse_section
            if @input.scan(/([^:]*?)\n/)
              section = @input[1].strip
              content = parse_section_pairs ||
                        parse_section_items
              @input.match?(/\n+/) || error("Unexpected end of section")
              @ast[section] = content
            else
              false
            end
          end

            def parse_section_items
              if @input.match?(/(\s+)([^:]*?)\n/)
                items = []
                indentation = @input[1].length
                while item = parse_section_items_item(indentation)
                  items << item
                end
                items
              else
                false
              end
            end

              def parse_section_items_item(indentation)
                if @input.scan(/\s{#{indentation}}(.*)\n/)
                  @input[1]
                else
                  false
                end
              end

            def parse_section_pairs
              contents = {}
              while content = parse_section_pair
                contents.merge!(content)
              end
              if !contents.empty?
                contents
              else
                false
              end
            end

              def parse_section_pair
                if @input.scan(/(\s+)(.*?):(\s+)(.*?)\n/)
                  key = @input[2].strip
                  values = [@input[4].strip]
                  indentation = @input[1].length + @input[2].length + 1 + @input[3].length
                  while value = parse_section_pair_newlinevalue(indentation)
                    values << value
                  end
                  { key => values.join("\n") }
                else
                  false
                end
              end

                def parse_section_pair_newlinevalue(indentation)
                  if @input.scan(/\s{#{indentation}}(.*)\n/)
                    @input[1]
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