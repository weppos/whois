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
      # = Web Adapter
      #
      # Special adapter intended to be used when you can only access
      # the WHOIS database via an online interface.
      #
      # This adapter should be considered like a {Whois::Server::Adapters::None}
      # adapter, just a little bit more specific.
      #
      class Web < Base

        # Always raises a {Whois::WebInterfaceError} exception
        # including the web address for the WHOIS inteface.
        #
        # @param  [String] string
        # @return [void]
        #
        # @raise  [Whois::WebInterfaceError] For every request.
        #
        def request(string)
          raise WebInterfaceError, options[:web]
        end

      end

    end
  end
end
