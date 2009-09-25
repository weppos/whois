#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client.
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
    # = Part
    #
    # A single <tt>Whois::Answer</tt> fragment. For instance, 
    # in case of thin server, an <tt>Whois::Answer</tt> may be composed by 
    # one or more parts corresponding to all responses 
    # returned by the WHOIS servers.
    #
    class Part < SuperStruct.new(:response, :host)
    end

  end
end