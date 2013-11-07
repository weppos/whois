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

      class WhoisNicHu < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_version,
            :scan_disclaimer,
            :scan_domain,
            :scan_available,
            :scan_in_progress,
            :scan_moreinfo,
        ]


        # FIXME: Requires UTF-8 Encoding (see #11)
        tokenizer :scan_available do
          if @input.match?(/Nincs (.*?) \/ No match\n/)
            @input.skip(/Nincs (.*?) \/ No match\n/)
            @ast["status:available"] = true
          end
        end

        # FIXME: Requires UTF-8 Encoding (see #11)
        tokenizer :scan_in_progress do
          if @input.match?(/(.*?) folyamatban \/ Registration in progress\n/)
            @input.skip(/(.*?) folyamatban \/ Registration in progress\n/)
            @ast["status:inprogress"] = true
          end
        end

        tokenizer :scan_disclaimer do
          if @input.match?(/^Rights.*\n/)
            lines = @input.scan_until(/^\n/)
            @ast["field:disclaimer"] = lines.strip
          end
        end

        tokenizer :scan_domain do
          if @input.match?(/^domain:\s+(.*)\n/) && @input.scan(/^domain:\s+(.*?)\n/)
            @ast["field:domain"] = @input[1].strip
          end
        end

        # FIXME: Requires UTF-8 Encoding (see #11)
        tokenizer :scan_moreinfo do
          if @input.match?(/Tov.* ld\.:\n/)
            @ast["field:moreinfo"] = @input.scan_until(/^\n/)
          end
        end

        tokenizer :scan_version do
          if @input.match?(/% Whois server .*\n/)
            @input.scan(/% Whois server ([\w\d\.]*).*?\n/)
            @ast["field:version"] = @input[1]
          end
        end

      end

    end
  end
end
