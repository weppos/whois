#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2017 Simone Carletti <weppos@weppos.net>
#++


module Whois
  class Server
    module Adapters

      #
      # = Verisign Adapter
      #
      # Provides ability to query Verisign WHOIS interfaces.
      #
      class Verisign < Base

        # Executes a WHOIS query to the Verisign WHOIS interface,
        # resolving any intermediate referral,
        # and appends the response to the client buffer.
        #
        # @param  [String] string
        # @return [void]
        #
        def request(string)
          response = query_the_socket("=#{string}", host)
          buffer_append response, host

          if options[:referral] != false && (referral = extract_referral(response))
            response = query_the_socket(string, referral)
            buffer_append(response, referral)
          end
        end


        private

        def extract_referral(response)
          if response =~ /Domain Name:/
            server = response.scan(/Registrar WHOIS Server:(.+?)$/i).flatten.last
            server.strip! if server != nil
            server
          end
        end

      end

    end
  end
end
