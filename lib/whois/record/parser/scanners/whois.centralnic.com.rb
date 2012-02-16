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

        # Scanner for the whois.centralnic.com record.
        #
        # @since 2.3.0
        class WhoisCentralnicCom < Base

          self.tokenizers += [
              :skip_empty_line,
              :scan_available,
              :scan_disclaimer,
              :scan_keyvalue,
          ]


          tokenizer :scan_available do
            if @input.skip(/^DOMAIN NOT FOUND\n/)
              @ast["status:available"] = true
            end
          end

          tokenizer :scan_disclaimer do
            if @input.match?(/^\S([^:]+)\n/)
              lines = []
              while @input.scan(/(.+)\n/)
                lines << @input[1].strip
              end
              @ast["field:disclaimer"] = lines.join(" ")
            end
          end

        end

      end
    end
  end
end
