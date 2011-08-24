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

        class WhoisTldEe < Scanners::Base

          def parse_content
            if @input.scan(/contact:\s+(.*)\n/)
              section = @input[1].strip
              content = {}

              while @input.scan(/(.*?):\s+(.*?)\n/)
                content[@input[1]] = @input[2]
              end

              @ast[section] = content
            # FIXME: incomplete scanner, it skips all the properties
            else
              @input.scan(/(.*)\n/)
            end
          end

        end

      end
    end
  end
end
