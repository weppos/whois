#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/super_struct'


module Whois
  class Answer

    # Holds the details of the Name Servers extracted from the WHOIS response.
    #
    # A name server is composed by the several attributes,
    # accessible through corresponding getter / setter methods.
    #
    # Please note that a response is not required to provide
    # all the attributes. When an attribute is not available,
    # the corresponding value is set to nil.
    #
    # @attr [String] name
    # @attr [String] ipv4
    # @attr [String] ipv6
    #
    class Nameserver < SuperStruct.new(:name, :ipv4, :ipv6)
    end

  end
end
