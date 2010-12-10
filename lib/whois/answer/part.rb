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

    # A single {Whois::Answer} fragment. For instance,
    # in case of *thin server*, a {Whois::Answer} can be composed by
    # one or more parts corresponding to all responses
    # returned by the WHOIS servers.
    #
    # A part is composed by a +body+ and a +host+.
    #
    # @attr [String] body The body containing the WHOIS output.
    # @attr [String] host The host which returned the body.
    #
    class Part < SuperStruct.new(:body, :host)
    end

  end
end
