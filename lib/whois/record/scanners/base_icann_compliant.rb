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

      # Scanner for the Icann Compliant-based records.
      class BaseIcannCompliant < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_available,
            :skip_head,
            :scan_keyvalue,
            :skip_end,
        ]

        NONE = [
          /^Domain not found\.\n/,
          /^Domain [\w\.]+ is not registered here\.\n/,
          /^We could not find the requested domain on our system/
        ]

        tokenizer :scan_available do
          if NONE.any? { |pattern| @input.skip_until(pattern) }
            @ast['status:available'] = true
          end
        end

        tokenizer :skip_head do
          if @input.skip_until(/^Domain Name:/)
            @input.scan(/\s(.+)\n/)
            @ast["Domain Name"] = @input[1].strip
          end
        end

        tokenizer :skip_end do
          @input.terminate
        end

      end

    end
  end
end
