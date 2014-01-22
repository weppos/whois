#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_verisign'


module Whois
  class Record
    class Parser

      # Parser for the ccwhois.verisign-grs.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class CcwhoisVerisignGrsCom < BaseVerisign
      end

    end
  end
end
