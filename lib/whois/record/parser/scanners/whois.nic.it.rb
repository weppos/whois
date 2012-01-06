#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/scanners/base'


module Whois
  class Record
    class Parser
      module Scanners

        class WhoisNicIt < Scanners::Base

          def parse_content
            parse_response_unavailable ||
            trim_newline      ||
            parse_disclaimer  ||
            parse_keyvalue    ||
            parse_section     ||
            error!("Unexpected token")
          end

        private

          def parse_response_unavailable
            if @input.scan(/Service temporarily unavailable\.\n/)
              @ast["response:unavailable"] = true
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
            end
          end

          def parse_keyvalue
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

          def parse_section
            if @input.scan(/([^:]+?)\n/)
              section = @input[1].strip
              content = parse_section_pairs ||
                        parse_section_items
              @input.match?(/\n+/) || error!("Unexpected end of section")
              @ast[section] = content
            end
          end

            def parse_section_items
              if @input.match?(/(\s+)([^:]+?)\n/)
                items = []
                indentation = @input[1].length
                while item = parse_section_items_item(indentation)
                  items << item
                end
                items
              end
            end

              def parse_section_items_item(indentation)
                if @input.scan(/\s{#{indentation}}(.+)\n/)
                  @input[1]
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
                if @input.scan(/(\s+)(.+?):(\s+)(.*?)\n/)
                  key = @input[2].strip
                  values = [@input[4].strip]
                  indentation = @input[1].length + @input[2].length + 1 + @input[3].length
                  while value = parse_section_pair_newlinevalue(indentation)
                    values << value
                  end
                  { key => values.join("\n") }
                end
              end

                def parse_section_pair_newlinevalue(indentation)
                  if @input.scan(/\s{#{indentation}}(.+)\n/)
                    @input[1]
                  end
                end

        end

      end
    end
  end
end
