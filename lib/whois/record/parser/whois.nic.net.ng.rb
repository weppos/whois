#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_cocca2'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.net.ng server.
      class WhoisNicNetNg < BaseCocca2

        property_supported :status do
          list = Array.wrap(node("Domain Status")).map(&:downcase)
          list.include?("available") ? :available : super()
        end

      end

    end
  end
end
