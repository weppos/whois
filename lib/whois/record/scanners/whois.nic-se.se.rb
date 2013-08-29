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
            :scan_pair,
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

        tokenizer :scan_pair do
          parse_pair(@ast)
        end

      private

        def parse_pair(store)
          if @input.scan(/(.+?):(.*)(\n|\z)/)
            key, value = @input[1].strip, @input[2].strip
            if store[key].nil?
              store[key] = value
            else
              store[key].is_a?(Array) || store[key] = [store[key]]
              store[key] << value
            end
            store
          end
        end


      end

    end
  end
end
