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

      class Formatted < Base

        def request(qstring)
          options[:format] || raise(ServerError, "Missing mandatory :format option for adapter `Formatted'")
          response = query_the_socket(sprintf(options[:format], qstring), host)
          append_to_buffer response, host
        end

      end

    end
  end
end
