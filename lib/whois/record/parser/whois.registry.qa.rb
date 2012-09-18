#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_shared1'


module Whois
  class Record
    class Parser

      # Parser for the whois.registry.qa server.
      #
      # @since  2.1.0
      class WhoisRegistryQa < BaseShared1
      end

    end
  end
end
