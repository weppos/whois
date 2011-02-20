#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/scanners/base'


module Whois
  class Answer
    class Parser
      module Scanners

        class Verisign < Base

          def parse_content
            trim_empty_line   ||
            parse_available   ||
            parse_disclaimer  ||
            parse_notice      ||
            parse_keyvalue    ||
            skip_iana_service ||
            skip_last_update  ||
            skip_fuffa        ||
            error!("Unexpected token")
          end


          def skip_last_update
            @input.scan(/>>>(.+?)<<<\n/)
          end

          def skip_fuffa
            (@input.scan(/^\S(.+)\n/)) ||
            (@input.scan(/^\S(.+)/) and @input.eos?)
          end

          def skip_iana_service
            if @input.match?(/IANA Whois Service/)
              @ast["IANA"] = true
              @input.terminate
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

          def parse_keyvalue
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

        end

      end
    end
  end
end
