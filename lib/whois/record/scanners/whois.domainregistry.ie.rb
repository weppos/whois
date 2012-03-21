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

      # Scanner for the whois.domainregistry.ie server.
      #
      # @since  RELEASE
      class WhoisDomainregistryIe < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_copyright,
            :scan_keyvalue,
            :scan_available,
        ]

        tokenizer :scan_available do
          if @input.skip(/^% Not Registered - .+\n/)
            @ast["status:available"] = true
          end
        end

        tokenizer :scan_copyright do
          if @input.match?(/^% Rights restricted by copyright/)
            lines = []
            while @input.scan(/^%(.+)\n/)
              lines << @input[1].strip
            end
            @ast["field:disclaimer"] = lines.join(" ")
          end
        end

      end
    end
  end
end
