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

      #
      # = None Adapter
      #
      # Special adapter intended to be used when a WHOIS interface
      # doesn't exist for given query.
      # For example, the domain authority for some TLD doesn't offer
      # any way to query for WHOIS data.
      #
      # In case the authority provides only a web based interface,
      # you should use the {Whois::Server::Adapters::Web} adapter.
      #
      # Every query for an object associated to a {Whois::Server::Adapters::None}
      # adapter raises a {Whois::NoInterfaceError} exception.
      #
      class None < Base

        # Always raises a {Whois::NoInterfaceError} exception.
        #
        # @param  [String] string
        # @return [void]
        #
        # @raise  [Whois::NoInterfaceError] For every request.
        #
        def request(string)
          raise NoInterfaceError, "This `#{type}' has no whois server"
        end

      end

    end
  end
end
