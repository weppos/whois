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

      # Scanner for the whois.ascio.com record.
      class WhoisAscioCom < Base

        self.tokenizers += [
            :scan_disclaimer,
            :scan_keyvalue,
        ]

        tokenizer :scan_disclaimer do
          if @input.match?(/^The data in Ascio Technologies/)
            @ast["field:disclaimer"] = _scan_lines_to_array(/(.+)\n/).join(" ")
          end
          @input.terminate
        end

      end

    end
  end
end
