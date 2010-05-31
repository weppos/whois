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

      class Pir < Base

        def request(qstring)
          response = ask_the_socket("FULL #{qstring}", "whois.publicinterestregistry.net", DEFAULT_WHOIS_PORT)
          append_to_buffer response, "whois.publicinterestregistry.net"

          if endpoint = extract_referral(response)
            response = ask_the_socket(qstring, endpoint, DEFAULT_WHOIS_PORT)
            append_to_buffer response, endpoint
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
