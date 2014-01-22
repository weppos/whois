#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_whoisd'
require 'whois/record/scanners/base_whoisd'


module Whois
  class Record
    class Parser

      # Parser for the whois.tld.ee server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisTldEe < BaseWhoisd
      end

    end
  end
end
