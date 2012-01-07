#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/scanners/base'


module Whois
  class Record
    class Parser
      module Scanners

        class Verisign < Base

          def parse_content
            trim_empty_line   ||
            parse_response_unavailable ||
            parse_available   ||
            parse_disclaimer  ||
            parse_notice      ||
            parse_indentedkeyvalue ||
            skip_ianaservice  ||
            skip_lastupdate   ||
            skip_fuffa        ||
            unexpected_token
          end

        private

          def skip_lastupdate
            @input.skip(/>>>(.+?)<<<\n/)
          end

          def skip_fuffa
            (@input.scan(/^\S(.+)\n/)) ||
            (@input.scan(/^\S(.+)/) and @input.eos?)
          end

          def skip_ianaservice
            if @input.match?(/IANA Whois Service/)
              @ast["IANA"] = true
              @input.terminate
            end
          end

          def parse_response_unavailable
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
                @input.scan_until(p)
                @ast["response:unavailable"] = true
              else
                visited!
              end
            end
          end

          def parse_available
            if @input.scan(/No match for "(.+?)"\.\n/)
              @ast["Domain Name"] = @input[1].strip
            end
          end

          def parse_notice
            if @input.match?(/^NOTICE:/)
              lines = []
              while @input.scan(/(.+)\n/)
                lines << @input[1].strip
              end
              @ast["Notice"] = lines.join(" ")
            end
          end

          def parse_disclaimer
            if @input.match?(/^TERMS OF USE:/)
              lines = []
              while @input.scan(/(.+)\n/)
                lines << @input[1].strip
              end
              @ast["Disclaimer"] = lines.join(" ")
            end
          end

          def parse_indentedkeyvalue
            if @input.scan(/\s+(.+?):(.*?)\n/)
              key, value = @input[1].strip, @input[2].strip
              if @ast[key].nil?
                @ast[key] = value
              else
                @ast[key].is_a?(Array) || @ast[key] = [@ast[key]]
                @ast[key] << value
              end
            end
          end

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
end
