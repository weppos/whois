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


module Whois

  module Version
    MAJOR = 0
    MINOR = 9
    TINY  = 0
    ALPHA = nil

    STRING = [MAJOR, MINOR, TINY, ALPHA].compact.join('.')
  end

  VERSION = Version::STRING

end