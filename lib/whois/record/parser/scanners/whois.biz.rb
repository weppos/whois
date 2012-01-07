#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/scanners/base'


module Whois
  class Record
    class Parser
      module Scanners

        class WhoisBiz < Base

          self.tokenizers += [
              :skip_empty_line,
              :scan_available,
              :scan_keyvalue,
              :skip_lastupdate,
              :skip_fuffa,
          ]


          tokenizer :scan_available do
            if @input.scan(/^Not found: (.+)\n/)
              @ast["Domain Name"] = @input[1]
              @ast["status:available"] = true
            end
          end

          tokenizer :skip_lastupdate do
            @input.skip(/>>>(.+?)<<<\n/)
          end

          tokenizer :skip_fuffa do
            @input.scan(/^\S(.+)\n/)
          end

        end

      end
    end
  end
end
