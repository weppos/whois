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

          if options[:referral] != false && referral = extract_referral(response)
            response = query_the_socket(string, referral)
            buffer_append(response, referral)
          end
        end


        private

        def extract_referral(response)
          if response =~ /Domain Name:/
            response.slice(/Whois Server:(\S+)/, 1)
          end
        end

      end

    end
  end
end
