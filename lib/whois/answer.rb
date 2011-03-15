#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


Whois.deprecate("The Whois::Answer object has been deprecated and will be removed in Whois 2.1. Please use Whois::Record instead.")

module Whois
  Answer = Record
end
