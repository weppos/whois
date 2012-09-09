#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/scanners/base'


module Whois
  class Record
    module Scanners

      # Scanner for the whois.sx record.
      #
      # @since  2.6.2
      class WhoisSx < Base

        self.tokenizers += [
            :skip_header,
            :skip_comments,
            :skip_empty_line,
            :flag_section_start,
            :flag_section_end,
            :scan_section,
            :scan_keyvalue,
        ]


        tokenizer :skip_header do
          if @input.pos == 0 && @input.match?(/^\[/)
            @input.skip_until(/\n/)
          end
        end

        tokenizer :skip_comments do
          if @input.match?(/^%/)
            @input.skip_until(/\n/)
          end
        end

        tokenizer :flag_section_start do
          if @input.scan(/(.+?):\n/)
            @tmp['section'] = @input[1].strip
          end
        end

        tokenizer :flag_section_end do
          # if @input.match?(/^\n/)
          #   @tmp.delete('section')
          # end
        end

        tokenizer :scan_section do
          if @tmp['section']
            lines = _scan_lines_to_array(/^(.+)\n/)

            # Check all lines to be sure there is no case where a value containing a :
            # is misinterpreted as key : value.

            # The section is a hash
            value = if lines.all? { |line| line.index(':', 1) }
              Hash[lines.map { |line| line.split(':', 2).map(&:strip) }]
            # The section is an array of values
            else
              lines
            end

            @ast[@tmp['section']] = value
            @tmp.delete('section')
          end
        end

      end

    end
  end
end
