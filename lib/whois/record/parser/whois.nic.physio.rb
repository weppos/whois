#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/whois.aridnrs.net.au'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.physio server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicPhysio < WhoisAridnrsNetAu
      end

    end
  end
end
