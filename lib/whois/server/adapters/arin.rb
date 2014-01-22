#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


module Whois
  class Server
    module Adapters

      #
      # = Arin Adapter
      #
      # Provides ability to query Arin WHOIS interfaces.
      #
      class Arin < Base

        # Executes a WHOIS query to the Arin WHOIS interface,
        # resolving any intermediate referral,
        # and appends the response to the client buffer.
        #
        # @param  [String] string
        # @return [void]
        #
        def request(string)
          response = query_the_socket("n + #{string}", host)
          buffer_append response, host

          if options[:referral] != false && (referral = extract_referral(response))
            response = query_the_socket(string, referral[:host], referral[:port])
            buffer_append(response, referral[:host])
          end
        end

        private

        def extract_referral(response)
          return unless response =~ /ReferralServer:\s*r?whois:\/\/([\w\.]+):?(\d+)/
          {
            host: $1,
            port: $2 ? $2.to_i : nil
          }
        end

      end

    end
  end
end
