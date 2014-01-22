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

      class Arpa < Base

        def request(string)
          record = Server.guess(inaddr_to_ip(string)).lookup(string)
          part   = record.parts.first
          buffer_append part.body, part.host
        end


        private

          # "127.1.168.192.in-addr.arpa" => "192.168.1.127"
          # "1.168.192.in-addr.arpa" => "192.168.1.0"
          # "168.192.in-addr.arpa" => "192.168.0.0"
          # "192.in-addr.arpa" => "192.0.0.0"
          # "in-addr.arpa" => "0.0.0.0"
          def inaddr_to_ip(string)
            unless /^([0-9]{1,3}\.?){0,4}in-addr\.arpa$/ =~ string
              raise ServerError, "Invalid .in-addr.arpa address"
            end
             a, b, c, d = string.scan(/[0-9]{1,3}\./).reverse
            [a, b, c, d].map do |token|
              token = (token ||= 0).to_i
              if token <= 255 && token >= 0
                token
              else
                raise ServerError, "Invalid .in-addr.arpa token `#{token}'"
              end
            end.join(".")
          end

      end

    end
  end
end
