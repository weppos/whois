# frozen_string_literal: true

#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2020 Simone Carletti <weppos@weppos.net>
#++


module Whois
  class Server
    module Adapters

      #
      # = Afilias Adapter
      #
      # Provides ability to query Afilias WHOIS interfaces.
      #
      class Afilias < Base

        # Executes a WHOIS query to the Afilias WHOIS interface,
        # resolving any intermediate referral,
        # and appends the response to the client buffer.
        #
        # @param  [String] string
        # @return [void]
        #
        def request(string)
          response = query_the_socket(string, host)
          buffer_append response, host

          if options[:referral] != false && (referral = extract_referral(response))
            response = query_the_socket(string, referral)
            buffer_append(response, referral)
          end
        end


        private

        def extract_referral(response)
          return unless (match = response.match(/Registrar WHOIS Server:(.+?)$/))

          server = match[match.size - 1].strip
          server.empty? ? nil : server
        end

      end

    end
  end
end
