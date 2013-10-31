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

      # Scanner for the discount-domain.com records.
      class GrsWhoisHichinaCom < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_available,
            :scan_disclaimer,
            :scan_keyvalue_withpoints,
        ]


        tokenizer :scan_available do
          if @input.scan_until(/Not Found!\n/)
            @ast["status:available"] = true
          end
        end

        tokenizer :scan_disclaimer do
          if @input.match?(/^\<a href=/)
            @ast["field:disclaimer"] = _scan_lines_to_array(/(.+)/m).join(" ").strip.delete("\n")
          end
        end

        tokenizer :join_line do
          @input.skip(/,\n/)
        end

        tokenizer :scan_keyvalue_withpoints do
          if @input.scan(/(.+[^\.{2,}])\s\.{3,}\s(.*)\n((?:\s{3,}.*)*)/)
            key, value = @input[1].strip, @input[2].strip.insert(-1, @input[3].delete("\n").gsub(/\s{3,}/, " "))
            
            target = @tmp['_section'] ? (@ast[@tmp['_section']] ||= {}) : @ast

            if target[key].nil?
              target[key] = value
            else
              target[key] = Array.wrap(target[key])
              target[key] << value
            end
          end
        end

      end

    end
  end
end
