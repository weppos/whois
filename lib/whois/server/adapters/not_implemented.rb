# frozen_string_literal: true

#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2024 Simone Carletti <weppos@weppos.net>
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
        def request(_string)
          raise ServerNotImplemented, "The `#{host}' feature has not been implemented yet."
        end

      end

    end
  end
end
