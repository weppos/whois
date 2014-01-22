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

      # Scanner for the whois.tucows.com record.
      class WhoisTucowsCom < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_disclaimer,
            :scan_keyvalue,
        ]

        tokenizer :scan_disclaimer do
          @input.skip_until(/The Data in the Tucows Registrar/m)
          @ast["field:disclaimer"] = 'The Data in the Tucows Registrar' << @input.scan_until(/.*$/m)
        end

      end

    end
  end
end
