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

      # Scanner for the IIS.se company.
      class BaseIisse < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_available,
            :scan_disclaimer,
            :scan_keyvalue,
        ]


        tokenizer :scan_available do
          if @input.skip(/^(domain )?"(.+)" not found.+\n/)
            @ast["status:available"] = true
          end
        end

        tokenizer :scan_disclaimer do
          if @input.match?(/# Copyright/)
            lines = []
            while !@input.match?(/# Result of/) && @input.scan(/#?(.*)\n/)
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
