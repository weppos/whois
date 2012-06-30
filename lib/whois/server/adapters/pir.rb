#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


module Whois
  class Server
    module Adapters

      #
      # = Public Internet Registry (PIR) Adapter
      #
      # Provides ability to query PIR WHOIS interfaces.
      #
      # The following WHOIS servers are currently known
      # to require the Pir adapter:
      #
      # - whois.publicinterestregistry.net
      #
      class Pir < Base

        # Executes a WHOIS query to the PIR WHOIS interface,
        # resolving any intermediate referral,
        # and appends the response to the client buffer.
        #
        # @param  [String] string
        # @return [void]
        #
        def request(string)
          response = query_the_socket("FULL #{string}", host)
          buffer_append response, host

          if endpoint = extract_referral(response)
            response = query_the_socket(string, endpoint)
            buffer_append response, endpoint
          end
        end


        private

          def extract_referral(response)
            if response =~ /Registrant Name:SEE SPONSORING REGISTRAR/ &&
               response =~ /Registrant Street1:Whois Server:(\S+)/
              $1
            end
          end

      end

    end
  end
end
