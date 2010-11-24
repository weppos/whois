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
    # = Contacts
    #
    # Holds the details of a <tt>Contact</tt> extracted from the WHOIS <tt>Answer</tt>.
    #
    # A <tt>Contact</tt> is composed by the following attributes:
    #
    # * <tt>:id</tt>:
    # * <tt>:type</tt>: the contact type (1 = registrant, 2 = admin, 3 = technical).
    # * <tt>:name</tt>:
    # * <tt>:organization</tt>:
    # * <tt>:address</tt>:
    # * <tt>:city</tt>:
    # * <tt>:zip</tt>:
    # * <tt>:state</tt>:
    # * <tt>:country</tt>:
    # * <tt>:country_code</tt>:
    # * <tt>:phone</tt>:
    # * <tt>:fax</tt>:
    # * <tt>:email</tt>:
    # * <tt>:created_on</tt>:
    # * <tt>:updated_on</tt>:
    #
    # Be aware that every WHOIS server can return a different number of details
    # or no details at all.
    #
    class Contact < SuperStruct.new(:id, :type, :name, :organization,
                                    :address, :city, :zip, :state, :country, :country_code,
                                    :phone, :fax, :email,
                                    :created_on, :updated_on)

      TYPE_REGISTRANT = 1
      TYPE_ADMIN = 2
      TYPE_TECHNICAL = 3

    end

  end
end
