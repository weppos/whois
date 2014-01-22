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

      # Scanner for the whois.srs.net.nz record.
      class WhoisSrsNetNz < Base

        self.tokenizers += [
            :skip_empty_line,
            :skip_comment,
            :scan_keyvalue,
        ]


        tokenizer :skip_comment do
          @input.skip(/^%.*\n/)
        end

      end

    end
  end
end
