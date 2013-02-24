#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_whoisd'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.cz server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicCz < BaseWhoisd
        self.status_mapping = {
          'paid and in zone' => :registered,
          'update prohibited' => :registered,
          'expired' => :expired,
          'to be deleted' => :expired,
        }
      end

    end
  end
end
