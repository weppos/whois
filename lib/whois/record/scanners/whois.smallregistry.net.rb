#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/scanners/base'


module Whois
  class Record
    module Scanners

      # Scanner for the whois.smallregistry.net record.
      class WhoisSmallregistryNet < Base

        self.tokenizers += [
            :scan_yaml_header,
            :scan_disclaimer,
            :scan_request_time,
            :scan_available,
            :scan_body,
        ]
        
        tokenizer :scan_yaml_header do
          # skip the YAML prelude
          @input.scan(/^---.*\n/)
        end

        tokenizer :scan_disclaimer do
          if @input.match?(/^#/) && disclaimer = @input.scan_until(/^#\n/)
            @ast["field:disclaimer"] = disclaimer
          end
        end

        tokenizer :scan_request_time do
          if @input.scan(/^# (\d+-\d+-\d+T.*)\n/)
            @ast["field:request_time"] = @input[1].strip
          end
        end

        tokenizer :scan_available do
          if @input.scan(/^# Object not found.*\n/)
            @ast["status:available"] = true
          end
        end

        tokenizer :scan_body do
          str = @input.rest
          str.gsub!(/ (![\w]+) \n/, " \n") # remove custom types
          @ast.merge! YAML.load(str)
          @input.terminate
        end

      end
    end
  end
end
