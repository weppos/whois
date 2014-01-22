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

      class BaseShared3 < Base

        self.tokenizers += [
            :scan_disclaimer,
            :skip_empty_line,
            :skip_comment,
            :scan_available,
            :scan_keyvalue,
        ]


        tokenizer :skip_comment do
          @input.skip(/^;.*\n/)
        end

        tokenizer :scan_available do
          if @input.skip(/^not found.+\n/)
            @ast["status:available"] = true
          end
        end

        tokenizer :scan_disclaimer do
          if @input.pos == 0 && @input.match?(/^;.*/)
            @ast["field:disclaimer"] = _scan_lines_to_array(/^;(.*)\n/).join(" ")
            @ast["field:disclaimer"].gsub!("  ", "\n")
          end
        end

      end

    end
  end
end
