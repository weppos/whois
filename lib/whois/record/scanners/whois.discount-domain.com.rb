#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/scanners/base'


module Whois
  class Record
    module Scanners

      # Scanner for the discount-domain.com records.
      class WhoisDiscountDomainCom < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_available,
            :scan_disclaimer,
            :scan_keyvalue,
        ]


        tokenizer :scan_available do
          if @input.scan_until(/No match for\s.+\.\n/)
            @ast["status:available"] = true
          end
        end

        tokenizer :scan_disclaimer do
          if @input.pos == 0 && @input.match?(/^(.+\n+){,3}\n/)
            @ast["field:disclaimer"] = _scan_lines_to_array(/^(.+\n)\n/m).join(" ")
          end
        end
      end

    end
  end
end
