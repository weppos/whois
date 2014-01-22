#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/super_struct'


module Whois
  class Record

    # Holds the details of the Name Servers extracted from the WHOIS response.
    #
    # A name server is composed by the several attributes,
    # accessible through corresponding getter / setter methods.
    #
    # Please note that a response is not required to provide
    # all the attributes. When an attribute is not available,
    # the corresponding value is set to nil.
    #
    # @attr [String] name
    # @attr [String] ipv4
    # @attr [String] ipv6
    #
    class Nameserver < SuperStruct.new(:name, :ipv4, :ipv6)

      # Returns a string representation of this object
      # composed by the host +name+.
      #
      # @example
      #   Nameserver.new(:name => "ns.example.com").to_s
      #   # => "ns.example.com"
      #   Nameserver.new.to_s
      #   # => ""
      #
      # @return [String] The string representation.
      def to_s
        name.to_s
      end

    end

  end
end
