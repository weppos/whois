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

        class WhoisPublicinternetregistryNet < Scanners::Base

          def parse_content
            parse_available   ||
            parse_throttled   ||
            parse_disclaimer  ||
            parse_pair        ||

            trim_empty_line   ||
            error!("Unexpected token")
          end


          def parse_available
            if @input.match?(/^NOT FOUND\n/)
              @ast["status-available"] = true
              @input.skip(/^.+\n/)
            end
          end

          def parse_throttled
            if @input.match?(/^WHOIS LIMIT EXCEEDED/)
              @ast["response-throttled"] = true
              @input.skip(/^.+\n/)
            end
          end

          def parse_disclaimer
            if @input.match?(/^NOTICE:/)
              lines = []
              while !@input.match?(/\n/) && @input.scan(/(.*)\n/)
                lines << @input[1].strip
              end
              @ast["Disclaimer"] = lines.join(" ")
            end
          end

          def parse_pair
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
