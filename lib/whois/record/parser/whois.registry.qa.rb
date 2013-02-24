#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_shared1'


module Whois
  class Record
    class Parser

      # Parser for the whois.registry.qa server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @since  2.1.0
      class WhoisRegistryQa < BaseShared1
      end

    end
  end
end
