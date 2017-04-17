require 'whois/record/scanners/base_whoisd'

module Whois
  class Record
    module Scanners
      class WhoisApnicNet < BaseWhoisd
        self.tokenizers += [
          :skip_blank_line
        ]
      end
    end
  end
end
