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

    #
    # = Nameserver
    #
    # Holds the details of the Name Servers extracted from the WHOIS answer.
    #
    # A Nameserver is composed by the following attributes:
    #
    # * <tt>:name</tt>:
    # * <tt>:ipv4</tt>:
    # * <tt>:ipv6</tt>:
    #
    # Be aware that every WHOIS server can return a different number of details
    # or no details at all.
    #
    class Nameserver < SuperStruct.new(:name, :ipv4, :ipv6)
    end

  end
end
