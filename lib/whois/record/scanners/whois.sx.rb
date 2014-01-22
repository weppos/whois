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

      class WhoisSx < Base

        self.tokenizers += [
            :skip_blank_line,
            :scan_available,
            :scan_keyvalue,
            :skip_lastupdate,
            :scan_disclaimer,
        ]


        tokenizer :scan_available do
          if @input.scan(/^Status: (.+) \(No match for domain "(.+)"\)\n/)
            @ast["Domain Status"] = @input[1]
            @ast["Domain Name"] = @input[2]
          end
        end

        tokenizer :skip_lastupdate do
          @input.skip(/>>>(.+?)<<<\n/)
        end

        tokenizer :scan_disclaimer do
          if @input.match?(/^% WHOIS LEGAL STATEMENT/)
            @ast["field:disclaimer"] = _scan_lines_to_array(/%(.*)\n/).map(&:strip).join("\n")
          end
        end

      end

    end
  end
end
