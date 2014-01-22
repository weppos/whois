#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_icb'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.io server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicIo < BaseIcb

        property_supported :domain do
          if reserved?
            nil
          else
            super()
          end
        end

        property_supported :status do
          if reserved?
            :reserved
          else
            super()
          end
        end


        # NEWPROPERTY
        def reserved?
          !!content_for_scanner.match(/^Domain reserved\n/)
        end

      end

    end
  end
end
