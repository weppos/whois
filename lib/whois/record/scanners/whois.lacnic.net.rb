require 'whois/record/scanners/base_whoisd'

module Whois
  class Record
    module Scanners
      class WhoisLacnicNet < BaseWhoisd
        self.tokenizers += [
          :skip_blank_line
        ]
      end
    end
  end
end
