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

        # Scanner for the whois.registry.qa record.
        #
        # @since  2.1.0
        class WhoisRegistryQa < Base

          self.tokenizers += [
              :skip_empty_line,
              :scan_available,
              :scan_keyvalue,
          ]


          tokenizer :scan_available do
            if @input.scan(/^No Data Found\n/)
              @ast["status:available"] = true
            end
          end

        end

      end
    end
  end
end
