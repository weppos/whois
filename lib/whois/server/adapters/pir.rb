#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


module Whois
  class Server
    module Adapters

      #
      # = Public Internet Registry (PIR) Adapter
      #
      # Provides ability to query PIR WHOIS interfaces.
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
          response = query_the_socket("FULL #{string}", "whois.publicinterestregistry.net", DEFAULT_WHOIS_PORT)
          buffer_append response, "whois.publicinterestregistry.net"

          if endpoint = extract_referral(response)
            response = query_the_socket(string, endpoint, DEFAULT_WHOIS_PORT)
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
