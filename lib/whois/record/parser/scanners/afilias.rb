#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/scanners/base'


module Whois
  class Record
    class Parser
      module Scanners

        class Afilias < Scanners::Base

          def parse_content
            parse_available   ||
            parse_disclaimer  ||
            parse_keyvalue    ||
            trim_newline      ||
            error!("Unexpected token")
          end

          def parse_available
            if @input.scan(/^NOT FOUND\n/)
              @ast["status-available"] = true
            end
          end

          def parse_disclaimer
            if @input.match?(/^Access to/)
              lines = []
              while @input.scan(/^(.+)\n/)
                lines << @input[1].strip
              end
              @ast["property-disclaimer"] = lines.join(" ")
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
