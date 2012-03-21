#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++

require 'whois/record/scanners/base'

module Whois
  class Record
    module Scanners

      #
      # = whois.cctld.by scanner
      #
      # Scanner for the whois.cctld.by server.
      #
      # @author Aliaksei Kliuchnikau <aliaksei.kliuchnikau@gmail.com>
      class WhoisCctldBy < Base

        self.tokenizers += [
          :skip_empty_line,
          :scan_available,
          :scan_keyvalue,
          :skip_empty_line,
          :skip_dash_line,
          :skip_provider_signature,
        ]

        tokenizer :scan_available do
          if @input.scan(/^Object does not exist/)
            @ast["status:available"] = true
          end
        end

        tokenizer :skip_dash_line do
          @input.skip(/^-+\n/)
        end

        tokenizer :skip_provider_signature do
          @input.scan(/^(.+)\n/)
        end
      end
    end
  end
end