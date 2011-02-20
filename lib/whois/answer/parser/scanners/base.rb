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


module Whois
  class Answer
    class Parser
      module Scanners

        class Base

          def initialize(content)
            @input = StringScanner.new(content)
          end

          def parse
            @ast = {}
            while !@input.eos?
              parse_content
            end
            @ast
          end


          def parse_content
            raise NotImplementedError
          end


          def trim_newline
            @input.scan(/\n/)
          end

          def error!(message)
            if @input.eos?
              raise ParserError, "Unexpected end of input."
            else
              raise ParserError, "#{message}: #{@input.peek(@input.string.length)}"
            end
          end

        end

      end
    end
  end
end