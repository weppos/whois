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

        # Scanner for the whois.registry.qa server response.
        #
        # @since  GIT:MASTER
        class WhoisRegistryQa < Scanners::Base

          def parse_content
            parse_available ||
            parse_keyvalue_spaced ||

            trim_empty_line ||
            error!("Unexpected token")
          end

          def parse_available
            if @input.scan(/^No Data Found\n/)
              @ast["status:available"] = true
            end
          end

          def parse_keyvalue_spaced
            if @input.scan(/(.+?):\s+(.*?)\n/)
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
