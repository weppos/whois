#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/scanners/base_whoisd'


module Whois
  class Record
    module Scanners

      class WhoisNicCz < BaseWhoisd

        self.tokenizers += [
            :scan_response_throttled,
        ]

        tokenizer :scan_response_throttled do
          if @input.match?(/Your connection limit exceeded\. Please slow down and try again later/)
            @ast["response:throttled"] = true
            @input.skip(/^.+\n/)
          end
        end

      end

    end
  end
end
