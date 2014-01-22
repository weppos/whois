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

      # Scanner for the Afilias-based records.
      class WhoisPirOrg < BaseAfilias

        tokenizer :scan_disclaimer do
          if @input.match?(/^Access to .ORG/)
            @ast["field:disclaimer"] = _scan_lines_to_array(/^(.+)\n/).join(" ")
          end
        end
      end

    end
  end
end
