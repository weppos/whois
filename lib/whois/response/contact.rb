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


require 'whois/response/super_struct'


module Whois
  class Response

    #
    # = Contacts
    #
    # Holds the details of a Contact extracted from the WHOIS response.
    #
    # A Contact is composed by the following attributes:
    #
    # <tt>:id</tt>::
    # <tt>:name</tt>::
    # <tt>:organization</tt>::
    # <tt>:address</tt>::
    # <tt>:city</tt>::
    # <tt>:country</tt>::
    # <tt>:country_code</tt>::
    # <tt>:created_on</tt>::
    # <tt>:updated_on</tt>::
    #
    # Be aware that every WHOIS server can return a different number of details
    # or no details at all.
    #
    class Contact < SuperStruct.new(:id, :name, :organization,
                                    :address, :city, :country, :country_code,
                                    :created_on, :updated_on)
    end

  end
end