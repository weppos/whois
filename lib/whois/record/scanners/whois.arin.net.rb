require 'whois/record/scanners/base'

module Whois
  class Record
    module Scanners

      class WhoisArinNet < Base
        self.tokenizers += [
          :skip_empty_line,
          :skip_comment,
          :scan_keyvalue
        ]

        tokenizer :skip_comment do
          @input.skip(/^#.*\n/)
        end
      end
    end
  end
end
