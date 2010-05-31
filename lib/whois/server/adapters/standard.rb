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
      # = Standard Adapter
      #
      # Provides ability to query standard WHOIS interfaces.
      # A standard WHOIS interface accepts socket requests containing the name of the domain
      # and returns a single response containing the answer for given query.
      #
      # By default the interface should listen on port 43.
      # This adapter also supports an optional port number.
      #
      class Standard < Base

        def request(qstring)
          response = query_the_socket(qstring, host)
          append_to_buffer response, host
        end

      end

    end
  end
end