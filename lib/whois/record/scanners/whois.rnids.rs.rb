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

      # Scanner for the whois.rnids.rs record.
      #
      # @since 2.4.0
      class WhoisRnidsRs < Base

        self.tokenizers += [
            :scan_available,
            :skip_comment,
            :flag_group_start,
            :scan_group_keyvalue,
            :flag_group_end,
            :skip_empty_line,
        ]


        GROUPS = ["Owner", "Administrative contact", "Technical contact"]

        tokenizer :scan_available do
          if @input.scan(/^%ERROR:103: Domain is not registered/)
            @ast["status:available"] = true
          end
        end

        tokenizer :flag_group_start do
          if GROUPS.any? { |group| @input.check(/^(#{group}):/) }
            @tmp["group"] = @input[1]
          end
          false
        end

        tokenizer :flag_group_end do
          if @input.match?(/^\n/)
            @tmp.delete("group")
          end
        end

        tokenizer :scan_group_keyvalue do
          if @input.scan(/(.+?):(.*?)\n/)
            key, value = @input[1].strip, @input[2].strip
            target = @tmp["group"] ? (@ast[@tmp["group"]] ||= {}) : @ast

            if target[key].nil?
              target[key] = value
            else
              target[key] = Array.wrap(target[key])
              target[key] << value
            end
          end
        end

        tokenizer :skip_comment do
          @input.skip(/^%.*\n/)
        end

      end

    end
  end
end
