#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/scanners/base'


module Whois
  class Record
    module Scanners

      # Scanner for Whoisd-based record.
      class Whoisd < Base

        self.tokenizers += [
            :skip_comment,
            :skip_empty_line,
            :scan_section,
            :scan_keyvalue,
        ]


        tokenizer :scan_section do
          if @input.scan(/(?:contact|nsset):\s+(.+)\n/)
            @tmp['_section'] = @input[1].strip
            while scan_keyvalue
            end
            @tmp.delete('_section')
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
