#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


module Whois

  # Holds information about library version.
  module Version
    MAJOR = 3
    MINOR = 4
    PATCH = 4
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join(".")
  end

  # The current library version.
  VERSION = Version::STRING

end
