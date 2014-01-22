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
      # = Standard Adapter
      #
      # Provides ability to query standard WHOIS interfaces.
      # A standard WHOIS interface accepts socket requests
      # containing the name of the domain and returns a single response
      # containing the record for given query.
      #
      #   a = Standard.new(:tld, ".it", "whois.nic.it")
      #   a.request("example.it")
      #
      # By default, WHOIS interfaces listen on port 43.
      # This adapter also supports an optional port number.
      #
      #   a = Standard.new(:tld, ".it", "whois.nic.it", :port => 20)
      #   a.request("example.it")"
      #
      # == Options
      #
      # The following options can be supplied to customize the creation
      # of a new instance:
      #
      # * +:port+ - Specifies a port number different than 43
      #
      class Standard < Base

        # Executes a WHOIS query to the WHOIS interface
        # listening at +host+ and appends the response
        # to the client buffer.
        #
        # The standard port of a WHOIS request is 43.
        # You can customize it by passing a +:port+ option.
        #
        # @param  [String] string
        # @return [void]
        #
        def request(string)
          response = query_the_socket(string, host)
          buffer_append response, host
        end

      end

    end
  end
end