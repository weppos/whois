require 'whois/record/scanners/base'

module Whois
  class Record
    module Scanners
      class WhoisRipeNet < Base

        RECORD_EXPR = %r((^\S+:\s+|^\s{2,})(.+)\n)

        self.tokenizers += [
          :skip_comment,
          :scan_section,
          :skip_newline
        ]

        tokenizer :skip_comment do
          @input.skip(/^%.*\n/)
        end

        tokenizer :scan_section do
          while @input.scan(RECORD_EXPR)
            match_array = @input.matched.split(':')
            input_key = match_array[0].strip.downcase
            if Handle::HANDLES.include? input_key
              @current_handle = "#{input_key}_handle".to_sym
            end
            @ast[@current_handle] = Hash.new
            save_entity match_array
            parse_section_pairs
          end
        end

        private
        def save_entity match_array
          if match_array.size > 1
            @last_key = key = match_array[0].strip.downcase
            value = match_array[1..-1].join(':').strip.downcase
          else
            key = @last_key
            value = match_array[0].strip.downcase
          end
          build_ast key, value
        end

        def build_ast key, value
          if !@ast[@current_handle].has_key? key
            @ast[@current_handle][key] = value
          elsif @ast[@current_handle][key].class == String
            @ast[@current_handle][key] = [@ast[@current_handle][key], value]
          else
            @ast[@current_handle][key] << value
          end
        end

        def parse_section_pairs
          while @input.scan(RECORD_EXPR)
            match_array = @input.matched.split(':')
            save_entity match_array
          end
        end
      end
    end
  end
end
