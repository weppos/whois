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
      # This adapter should be considered a <tt>Whois::Server::Adapters::None</tt>
      # adapter a little more specific.
      #
      class Web < Base

        # Always raises a <tt>Whois::WebInterfaceError</tt> exception
        # including the web address for the WHOIS inteface.
        #
        # Returns nothing.
        # Raises Whois::WebInterfaceError for every request.
        def request(qstring)
          raise WebInterfaceError, options[:web]
        end

      end

    end
  end
end
