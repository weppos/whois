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


require 'whois/record/parser/scanners/base'


module Whois
  class Record
    class Parser
      module Scanners

        class Cnnic < Scanners::Base

          def parse_content
            parse_reserved    ||
            parse_available   ||
            parse_keyvalue    ||
            trim_newline      ||
            error!("Unexpected token")
          end

          def parse_available
            if @input.scan(/^no matching record/)
              @ast["status-available"] = true
            end
          end

          def parse_reserved
            if @input.scan(/^the domain you want to register is reserved/)
              @ast["status-reserved"] = true
            end
          end

          def parse_keyvalue
            if @input.scan(/(.+?):(.*?)\n/)
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
