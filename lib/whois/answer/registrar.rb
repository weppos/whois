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
    # = Registrar
    #
    # Holds the details of the Registrar extracted from the WHOIS answer.
    #
    # A Registrar is composed by the following attributes:
    #
    # * <tt>:id</tt>:
    # * <tt>:name</tt>:
    # * <tt>:organization</tt>:
    # * <tt>:url</tt>:
    #
    # Be aware that every WHOIS server can return a different number of details
    # or no details at all.
    #
    class Registrar < SuperStruct.new(:id, :name, :organization, :url)
    end

  end
end
