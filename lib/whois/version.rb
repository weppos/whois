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
    PATCH = 0
    ALPHA = nil

    STRING = [MAJOR, MINOR, PATCH, ALPHA].compact.join('.')
  end

  VERSION = Version::STRING

end