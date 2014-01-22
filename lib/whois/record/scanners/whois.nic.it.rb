#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/scanners/base'


module Whois
  class Record
    module Scanners

      class WhoisNicIt < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_response_unavailable,
            :scan_disclaimer,
            :scan_keyvalue,
            :scan_section,
        ]


        tokenizer :scan_response_unavailable do
          if @input.scan(/Service temporarily unavailable\.\n/)
            @ast["response:unavailable"] = true
          end
        end

        tokenizer :scan_disclaimer do
          if @input.match?(/\*(.*?)\*\n/)
            @ast["Disclaimer"] = _scan_lines_to_array(/\*(.*?)\*\n/).select { |line| line =~ /\w+/ }.join(" ")
          end
        end

        tokenizer :scan_section do
          if @input.scan(/([^:]+?)\n/)
            section = @input[1].strip
            content = parse_section_pairs ||
                      parse_section_items
            @input.match?(/\n+/) || error!("Unexpected end of section")
            @ast[section] = content
          end
        end


      private

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
