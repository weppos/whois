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


Whois.deprecate("The Whois::Answer object has been deprecated and will be removed in Whois 2.1. Please use Whois::Record instead.")

module Whois
  Answer = Record
end
