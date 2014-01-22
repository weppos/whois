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

      # Scanner for Whoisd-based records.
      class BaseWhoisd < Base

        self.tokenizers += [
            :scan_available,
            :skip_comment,
            :scan_section,
            :scan_keyvalue,
            :skip_empty_line,
        ]


        tokenizer :scan_available do
          if @input.skip(/^%ERROR:101: no entries found/)
            @ast['status:available'] = true
          end
        end

        tokenizer :scan_section do
          if @input.scan(/\n(contact|nsset|keyset):\s+(.+)\n/)
            @tmp["_section"] = "node:#{@input[1]}/#{@input[2].strip}"
            while scan_keyvalue
            end
            @tmp.delete("_section")
          end
        end

        tokenizer :todo_content do
          @input.scan(/(.*)\n/)
        end

        tokenizer :skip_comment do
          @input.skip(/^%.*\n/)
        end

      end

    end
  end
end
