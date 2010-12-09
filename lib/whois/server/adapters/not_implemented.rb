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

        # Always raises a {Whois::ServerNotImplemented} exception.
        #
        # @param  [String] string
        # @return [void]
        #
        # @raise  [Whois::ServerNotImplemented] For every request.
        #
        def request(string)
          raise ServerNotImplemented, "The `#{host}' feature has not been implemented yet."
        end

      end

    end
  end
end
