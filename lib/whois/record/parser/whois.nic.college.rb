#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/whois.centralnic.com'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.college server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicCollege < WhoisCentralnicCom
      end

    end
  end
end
