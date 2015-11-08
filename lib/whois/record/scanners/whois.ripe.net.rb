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
            input_key = @input[1].strip.chomp(':').downcase
            if Handle::HANDLES.include? input_key
              @current_handle = "#{input_key}_handle".to_sym
            end
            @ast[@current_handle] = Hash.new
            parse_section_pairs
          end
        end

        private
        def parse_section_pairs
          contents = {}
          while @input.scan(RECORD_EXPR)
            match_array = @input.matched.split(':')

            if match_array.size > 1
              @last_key = key = match_array[0].strip.downcase.to_sym
              value = match_array[1..-1].join(':').strip.downcase
            else
              key = @last_key
              value = match_array[0].strip.downcase
            end

            if !@ast[@current_handle].has_key? key
              @ast[@current_handle][key] = value
            elsif @ast[@current_handle][key].class == String
              @ast[@current_handle][key] = [@ast[@current_handle][key], value]
            else
              @ast[@current_handle][key] << value
            end
          end
        end
      end
    end
  end
end
