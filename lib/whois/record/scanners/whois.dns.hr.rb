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

      # Scanner for the whois.dns.hr record.
      #
      # @since  2.4.0
      class WhoisDnsHr < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_available,
            :scan_keyvalue,
        ]


        tokenizer :scan_available do
          if @input.skip(/^%ERROR: no entries found\n/)
            @ast["status:available"] = true
          end
        end

      end

    end
  end
end
