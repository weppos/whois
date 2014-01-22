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
      # = Formatted Adapter
      #
      # The {Formatted} adapter is almost equal to the {Standard} adapter.
      # It accepts a +:format+ adapter to format the WHOIS query.
      #
      #   a = Standard.new(:tld, ".it", "whois.nic.it", :format => "HELLO %s")
      #   # performs a query for the string "HELLO example.it"
      #   a.request("example.it")
      #
      # == Options
      #
      # The following options can be supplied to customize the creation
      # of a new instance:
      #
      # * +:port+ - Specifies a port number different than 43
      # * +:format+ - Specifies the format rule to apply to the query string
      #
      # @see Whois::Server::Adapters::Standard
      #
      class Formatted < Base

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
        # @raise  [Whois::ServerError] If the :format option is missing.
        #
        def request(string)
          options[:format] || raise(ServerError, "Missing mandatory :format option for adapter `Formatted'")
          response = query_the_socket(sprintf(options[:format], string), host)
          buffer_append response, host
        end

      end

    end
  end
end
