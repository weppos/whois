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

      # Scanner for the whois.rnids.rs record.
      class WhoisRnidsRs < Base

        self.tokenizers += [
            :scan_available,
            :skip_comment,
            :flag_section_start,
            :scan_keyvalue,
            :flag_section_end,
            :skip_empty_line,
            :skip_privacy,
        ]


        SECTIONS = ["Owner", "Administrative contact", "Technical contact"]

        tokenizer :scan_available do
          if @input.scan(/^%ERROR:103: Domain is not registered/)
            @ast["status:available"] = true
          end
        end

        tokenizer :flag_section_start do
          if SECTIONS.any? { |section| @input.check(/^(#{section}):/) }
            @tmp['_section'] = @input[1]
          end
          false
        end

        tokenizer :flag_section_end do
          if @input.match?(/^\n/)
            @tmp.delete('_section')
          end
        end

        tokenizer :skip_comment do
          @input.skip(/^%.*\n/)
        end

        tokenizer :skip_privacy do
          @input.skip(/^Whois privacy has been activated for domain.\n/)
        end

      end

    end
  end
end
