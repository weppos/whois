require 'whois/record/scanners/base'

module Whois
  class Record
    module Scanners
      class WhoisNicOrKr < Base
        self.tokenizers += [
          :skip_blank_line,
          :skip_comment,
          :skip_korean,
          :skip_disclaimer,
          :flag_section_start,
          :scan_keyvalue,
          :flag_section_end,
          :terminate_on_lines
        ]

        SECTIONS = ["Network Information", "Admin Contact Information",
          "Tech Contact Information", "Network Abuse Contact Information"]

        tokenizer :skip_comment do
          @input.skip(/^#.*\n/)
        end

        tokenizer :skip_korean do
          @input.skip_until(/^# ENGLISH.*\n/)
        end

        tokenizer :skip_disclaimer do
          @input.skip(/^KRNIC is not an ISP but a National Internet Registry similar to APNIC./)
        end

        tokenizer :flag_section_start do
          # byebug
          if SECTIONS.any? { |section| @input.scan(/^\[ (#{section}) \]/) }
            @tmp['_section'] = @input[1]
          end
          false
        end

        tokenizer :flag_section_end do
          if @input.match?(/^\n/)
            @tmp.delete('_section')
          end
        end

        tokenizer :terminate_on_lines do
          @input.terminate if @input.match?(/^-*/)
        end
      end
    end
  end
end
