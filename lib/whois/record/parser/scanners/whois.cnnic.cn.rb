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

        # Scanner for the whois.cnnic.cn record.
        class WhoisCnnicCn < Base

          self.tokenizers += [
              :skip_empty_line,
              :scan_reserved,
              :scan_available,
              :scan_keyvalue,
          ]


          tokenizer :scan_available do
            if @input.scan(/^no matching record/)
              @ast["status:available"] = true
            end
          end

          tokenizer :scan_reserved do
            if @input.scan(/^the domain you want to register is reserved/)
              @ast["status:reserved"] = true
            end
          end

        end

      end
    end
  end
end
