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

      class Verisign < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_response_unavailable,
            :scan_available,
            :scan_disclaimer,
            :scan_notice,
            :scan_keyvalue_indented,
            :skip_ianaservice,
            :skip_lastupdate,
            :skip_fuffa,
        ]


        tokenizer :scan_response_unavailable do
          # Check if the string starts with /*
          # If it does, match until the end of all /* lines
          # or the end of the file and check for the content.
          #
          # Flag the block as visited to force the scanner to ignore this tokenizer
          # if already used and the content didn't match the unavailable message.
          if @input.match?(/^\*\n/) && !visited?
            p = /^[^\*]|\z/
            y = @input.check_until(p) =~ /^\* Sorry, the Whois database is currently down/

            if y
              @input.skip_until(p)
              @ast["response:unavailable"] = true
            else
              visited!
            end
          end
        end

        tokenizer :scan_available do
          if @input.scan(/No match for "(.+?)"\.\n/)
            @ast["Domain Name"] = @input[1].strip
          end
        end

        tokenizer :scan_disclaimer do
          if @input.match?(/^TERMS OF USE:/)
            @ast["Disclaimer"] = _scan_lines_to_array(/(.+)\n/).join(" ")
          end
        end

        tokenizer :scan_notice do
          if @input.match?(/^NOTICE:/)
            @ast["Notice"] = _scan_lines_to_array(/(.+)\n/).join(" ")
          end
        end

        tokenizer :scan_keyvalue_indented do
          if @input.scan(/\s+(.+?):(.*?)\n/)
            key, value = @input[1].strip, @input[2].strip
            if @ast[key].nil?
              @ast[key] = value
            else
              @ast[key] = [@ast[key]] unless @ast[key].is_a?(Array)
              @ast[key] << value
            end
          end
        end

        tokenizer :skip_lastupdate do
          @input.skip(/>>>(.+?)<<<\n/)
        end

        tokenizer :skip_fuffa do
          @input.scan(/^\S(.+)(?:\n|\z)/)
        end

        tokenizer :skip_ianaservice do
          if @input.match?(/IANA Whois Service/)
            @ast["IANA"] = true
            @input.terminate
          end
        end

      private

        def visited?
          !!@tmp["visited:#{@input.pos}"]
        end

        def visited!
          @tmp["visited:#{@input.pos}"] = true
          nil
        end

      end

    end
  end
end
