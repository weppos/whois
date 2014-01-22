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

      # Scanner for the whois.nc record.
      class WhoisNc < Base

        self.tokenizers += [
            :skip_empty_line,
            :skip_more,
            :scan_available,
            :scan_keyvalue,
        ]


        MORES = ['Whois \.NC', 'more details on']

        tokenizer :scan_available do
          if @input.skip(/^No entries found .+\n/)
            @ast["status:available"] = true
          end
        end

        tokenizer :skip_more do
          MORES.any? { |more| @input.skip(/^#{more}.*\n/) }
        end

      end

    end
  end
end
