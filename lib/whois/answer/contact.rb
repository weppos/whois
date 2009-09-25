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
    # = Contacts
    #
    # Holds the details of a Contact extracted from the WHOIS answer.
    #
    # A Contact is composed by the following attributes:
    #
    # <tt>:id</tt>::
    # <tt>:name</tt>::
    # <tt>:organization</tt>::
    # <tt>:address</tt>::
    # <tt>:city</tt>::
    # <tt>:zip</tt>::
    # <tt>:state</tt>::
    # <tt>:country</tt>::
    # <tt>:country_code</tt>::
    # <tt>:phone</tt>::
    # <tt>:fax</tt>::
    # <tt>:email</tt>::
    # <tt>:created_on</tt>::
    # <tt>:updated_on</tt>::
    #
    # Be aware that every WHOIS server can return a different number of details
    # or no details at all.
    #
    class Contact < SuperStruct.new(:id, :name, :organization,
                                    :address, :city, :zip, :state, :country, :country_code,
                                    :phone, :fax, :email,
                                    :created_on, :updated_on)
    end

  end
end