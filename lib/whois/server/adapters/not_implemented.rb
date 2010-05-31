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

      class NotImplemented < Base

        # Returns nothing.
        # Raises Whois::ServerNotImplemented for every request.
        def request(qstring)
          raise ServerNotImplemented, "The `#{host}' feature has not been implemented yet."
        end

      end

    end
  end
end
