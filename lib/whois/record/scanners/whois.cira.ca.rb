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

      # Scanner for the whois.cira.ca record.
      class WhoisCiraCa < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_disclaimer,
            :skip_comment,
            :scan_header,
            :scan_keyvalue,
            :scan_nameserver,
        ]

        
        tokenizer :scan_disclaimer do
          if @input.match?(/^% Use of CIRA/)
            @ast["field:disclaimer"] = _scan_lines_to_array(/^%(.*)\n/).join("\n")
          end
        end

        tokenizer :scan_header do
          if @input.scan(/^(.+?):\n/)
            @tmp["group"] = @input[1]
          end
        end

        tokenizer :scan_keyvalue do
          if @input.scan(/^(.+?):(.*?)\n/)
            start = @input[1]
            key, value = start.strip, @input[2].strip

            # This is a nested key
            target = if start.index(" ") == 0
              error!("Expected group.") if @tmp["group"].nil?
              @ast[@tmp["group"]] ||= {}
              @ast[@tmp["group"]]
            else
              @tmp.delete("group")
              @ast
            end

            more  = _scan_lines_to_array(/^\s{#{start.size}}(.+)\n/)
            value = more.unshift(value).join("\n") unless more.empty?

            if target[key].nil?
              target[key] = value
            else
              target[key] = Array.wrap(target[key])
              target[key] << value
            end
          end
        end

        tokenizer :scan_nameserver do
          if @input.scan(/^\s+(.+?)\n/) && @tmp["group"] == "Name servers"
            @ast["field:nameservers"] ||= []
            @ast["field:nameservers"] <<  @input[1].strip
          end
        end

        tokenizer :skip_comment do
          @input.skip(/^%.*\n/)
        end

      end

    end
  end
end
