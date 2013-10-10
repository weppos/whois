#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/scanners/base'


module Whois
  class Record
    module Scanners

      # Scanner for the whois.gandi.net record.
      class WhoisGandiNet < Base

        self.tokenizers += [
            :scan_yaml_header,
            :skip_empty_line,
            :scan_available,
            :scan_disclaimer,
            :scan_keyvalue,
        ]

        tokenizer :scan_yaml_header do
          # skip the YAML prelude
          @input.scan(/^---.*\n/)
        end

        tokenizer :scan_available do
          if @input.skip(/^# Not found/)
            @ast["status:available"] = true
          end
        end

        tokenizer :scan_disclaimer do
          if @input.match?(/^#.*/)
            @ast["field:disclaimer"] = _scan_lines_to_array(/^#(.*)\n/).join(" ")
            @ast["field:disclaimer"].gsub!("  ", "\n").gsub!(/\n\d{4}-\d{2}-\d{2}.*CEST/,'')
          end
        end

      end
    end
  end
end
