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

      # Scanner for the whois.domainregistry.ie server.
      class WhoisDomainregistryIe < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_disclaimer,
            :scan_contact,
            :scan_keyvalue,
            :scan_available,
            :skip_application_pending,
        ]

        tokenizer :scan_available do
          if @input.skip(/^% Not Registered - .+\n/)
            @ast["status:available"] = true
          end
        end

        tokenizer :scan_disclaimer do
          if @input.match?(/^% Rights restricted by copyright/)
            @ast["field:disclaimer"] = _scan_lines_to_array(/^%(.+)\n/).join("\n")
          end
        end

        tokenizer :scan_contact do
          if @input.match?(/^person:/)
            lines = _scan_lines_to_hash(/(.+?):(.*?)\n/)
            @ast["field:#{lines['nic-hdl']}"] = lines
          end
        end

        tokenizer :skip_application_pending do
          if @input.match?(/^% Application Pending/)
            _scan_lines_to_array(/^%(.+)\n/)
            @ast["status:pending"] = true
          end
        end

      end
    end
  end
end
