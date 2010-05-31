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
      # = None Adapter
      #
      # Special adapter intended to be used when a WHOIS interface
      # doesn't exist for given query.
      # For example, the domain authority for some TLD doesn't offer
      # any way to query for WHOIS data.
      #
      # In case the authority provides only a web based interface,
      # you should use the <tt>Whois::Server::Adapters::Web</tt> adapter.
      #
      # Every query for an object associated to a <tt>Whois::Server::Adapters::None</tt>
      # adapter raises a <tt>Whois::NoInterfaceError</tt> exception.
      #
      class None < Base

        # Always raises a <tt>Whois::NoInterfaceError</tt> exception.
        #
        # Returns nothing.
        # Raises Whois::NoInterfaceError for every request.
        def request(qstring)
          raise NoInterfaceError, "This `#{type}' has no whois server"
        end

      end

    end
  end
end
