#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_shared3'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.gd server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicGd < BaseShared3

        property_supported :status do
          if reserved?
            :reserved
          else
            super()
          end
        end

        property_supported :available? do
          if reserved?
            false
          else
            super()
          end
        end

        # NEWPROPERTY
        def reserved?
          !!content_for_scanner.match(/RESTRICTED/)
        end

      end

    end
  end
end
