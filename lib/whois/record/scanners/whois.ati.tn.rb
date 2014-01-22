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

      # Scanner for the whois.ati.tn record.
      class WhoisAtiTn < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_available,
            :scan_disclaimer,
            :scan_keyvalue,
        ]


        tokenizer :scan_available do
          if @input.skip(/^Domain (.+) not found/)
            @ast["status:available"] = true
          end
        end

        tokenizer :scan_disclaimer do
          if @input.match?(/^All rights reserved/)
            @ast["field:disclaimer"] = _scan_lines_to_array(/(.+)\n/).join("\n")
          end
        end

      end

    end
  end
end
