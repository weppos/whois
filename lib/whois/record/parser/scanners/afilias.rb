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

        class Afilias < Scanners::Base

          def parse_content
            parse_available   ||
            parse_reserved    ||  # .XXX
            parse_throttled   ||  # .ORG
            parse_disclaimer  ||
            parse_keyvalue    ||

            trim_empty_line   ||
            unexpected_token
          end

          def parse_available
            if @input.scan(/^NOT FOUND\n/)
              @ast["status:available"] = true
            end
          end

          def parse_reserved
            if @input.scan(/^Reserved by ICM Registry\n/)
              @ast["status:reserved"] = true
            end
          end

          def parse_throttled
            if @input.match?(/^WHOIS LIMIT EXCEEDED/)
              @ast["response:throttled"] = true
              @input.skip(/^.+\n/)
            end
          end

          def parse_disclaimer
            if @input.pos == 0 && @input.match?(/^(.+\n){3,}\n/)
              lines = []
              while @input.scan(/^(.+)\n/)
                lines << @input[1].strip
              end
              @ast["property:disclaimer"] = lines.join(" ")
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
