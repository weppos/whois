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

      # Scanner for the Afilias-based records.
      class BaseAfilias < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_available,
            :scan_reserved,
            :scan_throttled,
            :scan_disclaimer,
            :scan_keyvalue,
        ]


        tokenizer :scan_available do
          if @input.scan(/^NOT FOUND\n/)
            @ast["status:available"] = true
          end
        end

        # .XXX
        tokenizer :scan_reserved do
          if @input.scan(/^Reserved by ICM Registry\n/)
            @ast["status:reserved"] = true
          end
        end

        # .ORG
        tokenizer :scan_throttled do
          if @input.match?(/^WHOIS LIMIT EXCEEDED/)
            @ast["response:throttled"] = true
            @input.skip(/^.+\n/)
          end
        end

        tokenizer :scan_disclaimer do
          if @input.pos == 0 && @input.match?(/^(.+\n){3,}\n/)
            @ast["field:disclaimer"] = _scan_lines_to_array(/^(.+)\n/).join(" ")
          end
        end
      end

    end
  end
end
