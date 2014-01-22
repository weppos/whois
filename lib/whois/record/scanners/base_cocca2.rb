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

      class BaseCocca2 < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_disclaimer,
            :skip_lastupdate,
            :skip_token_additionalsection,
            :scan_keyvalue,
        ]


        DISCLAIMER_MATCHES = [
          "TERMS OF USE:", # global
          "Terminos de Uso:", # whois.nic.hn
          "The data in the WHOIS database of Meridian", # whois.meridiantld.net
        ]

        tokenizer :scan_disclaimer do
          if @input.match?(/^#{DISCLAIMER_MATCHES.join("|")}/)
            @ast["field:disclaimer"] = @input.scan_until(/>>>/)
          end
        end

        tokenizer :skip_lastupdate do
          @input.skip(/>>>(.+?)<<<\n/)
        end

        tokenizer :skip_token_additionalsection do
          @input.skip(/Additional Section\n/)
        end

      end

    end
  end
end
