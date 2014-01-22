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

    # A single {Whois::Record} fragment. For instance,
    # in case of *thin server*, a {Whois::Record} can be composed by
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
