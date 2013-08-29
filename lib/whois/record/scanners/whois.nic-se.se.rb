#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/scanners/base'


module Whois
  class Record
    module Scanners

      class WhoisNicSeSe < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_available,
            :scan_disclaimer,
            :scan_keyvalue,
        ]


        tokenizer :scan_available do
          @ast["status:available"] = true if @input.skip(/".*" not found\.\n/)
        end

        tokenizer :scan_disclaimer do
          if @input.match?(/# Copyright \(c\) [\d-]* \.SE \(The Internet Infrastructure Foundation\)\.\n# All rights reserved\.\n\n/)
            lines = []
            while !@input.match?(/# Result of search for registered domain names under\n/) && @input.scan(/#?(.*)\n/)
              lines << @input[1].strip unless @input[1].strip == ""
            end
            @input.skip_until(/# printed with .+ bits\.\n/m)
            @ast["field:disclaimer"] = lines.join(" ")
          end
        end

      end

    end
  end
end
