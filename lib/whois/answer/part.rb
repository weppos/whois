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
    # A single answer fragment. For instance, in case of thin server,
    # an answer may be composed by more parts corresponding
    # to all responses returned by the whois servers.
    #
    class Part < SuperStruct.new(:response, :host)
    end

  end
end