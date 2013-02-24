#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_afilias'


module Whois
  class Record
    class Parser

      # Parser for the whois.pir.org server.
      class WhoisPirOrg < BaseAfilias

        # Checks whether the response has been throttled.
        #
        # @return [Boolean]
        #
        # @example
        #   WHOIS LIMIT EXCEEDED - SEE WWW.PIR.ORG/WHOIS FOR DETAILS
        #
        def response_throttled?
          !!node("response:throttled")
        end

      private

        def decompose_registrar(value)
          if value =~ /(.+?) \((.+?)\)/
            [$2, $1]
          end
        end

      end

    end
  end
end
