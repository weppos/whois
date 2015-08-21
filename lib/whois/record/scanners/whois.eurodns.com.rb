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

      # Scanner for Eurodns records, divergence from verisign server.
      class WhoisEurodnsCom < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_available,
            :scan_reserved,
            :scan_throttled,
            :scan_keyvalue,
            :skip_ianaservice,
            :skip_lastupdate,
            :skip_fuffa,
        ]

        tokenizer :scan_available do
          if @input.scan(/^NOT FOUND\n/)
            @ast["status:available"] = true
          end
        end

        tokenizer :scan_reserved do
          if settings[:pattern_reserved] && @input.scan(settings[:pattern_reserved])
            @ast["status:reserved"] = true
          end
        end

        tokenizer :scan_throttled do
          if @input.match?(/^WHOIS LIMIT EXCEEDED/)
            @ast["response:throttled"] = true
            @input.skip(/^.+\n/)
          end
        end

        tokenizer :skip_lastupdate do
          @input.skip(/>>>(.+?)<<<\n/)
        end

        tokenizer :skip_fuffa do
          @input.scan(/^\S(.+)(?:\n|\z)/)
        end

        tokenizer :skip_ianaservice do
          if @input.match?(/IANA Whois Service/)
            @ast["IANA"] = true
            @input.terminate
          end
        end
      end
    end
  end
end
