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

        # Scanner for the whois.tld.ee record.
        #
        # @todo This is an incomplete scanner, it skips all the properties
        #       except contacts.
        class WhoisTldEe < Base

          self.tokenizers += [
              :scan_contact,
              :todo_content,
          ]


          tokenizer :scan_contact do
            if @input.scan(/contact:\s+(.*)\n/)
              section = @input[1].strip
              content = {}

              while @input.scan(/(.*?):\s+(.*?)\n/)
                content[@input[1]] = @input[2]
              end

              @ast[section] = content
            end
          end

          tokenizer :todo_content do
            @input.scan(/(.*)\n/)
          end

        end

      end
    end
  end
end
