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
            :skip_head,
            :scan_available,
            :skip_empty_line,
            :skip_blank_line,
            :scan_keyvalue,
            :skip_end,
        ]

        NONE = [
          /^Domain not found\.\n/, 
          /is not registered here.\n/, 
          /^Unknown domain name.+\n/, 
          /^No matching domain name found\.\n/, 
          /^No details found/, 
          /^We could not find the requested domain on our system/,
        ]

        tokenizer :scan_available do
          if NONE.any? {|none| @input.skip_until(none)}
              @ast['status:available'] = true
          end
        end

        tokenizer :skip_head do
          if @input.skip_until(/Domain Name:/)
            @input.scan(/\s(.+)\n/)
            @ast['domain:name'] = @input[1].strip
          end
        end

        tokenizer :skip_end do
          @input.skip_until(/.*$/m)
        end

      end

    end
  end
end
