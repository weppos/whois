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


require 'whois/answer/parser/base'


module Whois
  class Answer
    class Parser

      #
      # = whois.example.com parser
      #
      # Parser for the whois.example.com server.
      #
      class WhoisExampleCom < Base

        # Public: Gets the registry disclaimer that comes with the answer.
        #
        # Returns a String with the disclaimer if available,
        # <tt>nil</tt> otherwise.
        property_supported :disclaimer do
          @disclaimer ||= nil
        end


        # Public: Gets the domain name as stored by the registry.
        #
        # Returns a String with the domain name if available,
        # <tt>nil</tt> otherwise.
        property_supported :domain do
          @domain ||= nil
        end

        # Public: Gets the unique domain ID as stored by the registry.
        #
        # Returns a String with the domain ID if available,
        # <tt>nil</tt> otherwise.
        property_supported :domain_id do
          @domain_id ||= nil
        end


        # Public: Gets the record status or statuses.
        #
        # Returns a String/Array with the record status if available,
        # <tt>nil</tt> otherwise.
        property_supported :status do
          @status ||= nil
        end

        # Public: Checks whether this record is available.
        #
        # Returns true/false depending whether this record is available.
        property_supported :available? do
          @available ||= nil
        end

        # Public: Checks whether this record is registered.
        #
        # Returns true/false depending this record is available.
        property_supported :registered? do
          @registered ||= nil
        end


        # Public: Gets the date the record was created,
        # according to the registry answer.
        #
        # Returns a Time object representing the date the record was created or
        # <tt>nil</tt> otherwise.
        property_supported :created_on do
          @created_on ||= nil
        end

        # Public: Gets the date the record was last updated,
        # according to the registry answer.
        #
        # Returns a Time object representing the date the record was last updated or
        # <tt>nil</tt> if not available.
        property_supported :updated_on do
          @updated_on ||= nil
        end

        # Public: Gets the date the record is set to expire,
        # according to the registry answer.
        #
        # Returns a Time object representing the date the record is set to expire or
        # <tt>nil</tt> if not available.
        property_supported :expires_on do
          @expires_on ||= nil
        end


        # Public: Gets the registrar object containing the registrar details
        # extracted from the registry answer.
        #
        # Returns an instance of <tt>Whois::Answer::Registrar</tt> representing the registrar or
        # <tt>nil</tt> if not available.
        property_supported :registrar do
          @registrar ||= nil
        end


        # Public: Gets the registrant contact object containing the details of the record owner
        # extracted from the registry answer.
        #
        # Returns an instance of <tt>Whois::Answer::Contact</tt> representing the registrant contact or
        # <tt>nil</tt> if not available.
        property_supported :registrant_contact do
          @registrant_contact ||= nil
        end

        # Public: Gets the administrative contact object containing the details of the record administrator
        # extracted from the registry answer.
        #
        # Returns an instance of <tt>Whois::Answer::Contact</tt> representing the administrative contact or
        # <tt>nil</tt> if not available.
        property_supported :admin_contact do
          @admin_contact ||= nil
        end

        # Public: Gets the technical contact object containing the details of the technical representative
        # extracted from the registry answer.
        #
        # Returns an instance of <tt>Whois::Answer::Contact</tt> representing the technical contact or
        # <tt>nil</tt> if not available.
        property_supported :technical_contact do
          @technical_contact ||= nil
        end


        # Public: Gets the list of name server entries for this record,
        # extracted from the registry answer.
        #
        # Examples
        #
        #   nameserver
        #   # => []
        #   nameserver
        #   # => ["ns2.google.com", "ns1.google.com", "ns3.google.com"]
        #
        #
        # Returns an Array of lower case String where each String is a name server entry,
        # an empty Array if no name server was found.
        property_supported :nameservers do
          @nameservers ||= []
        end


        # Public: Checks whether this answer is different than <tt>other</tt>.
        #
        # Comparing the Answer contents is not always as trivial as it seems.
        # Whois servers sometimes inject dynamic method into the whois answer such as
        # the timestamp the request was generated.
        # This causes two answers to be different even if they actually should be considered equal
        # because the registry data didn't change.
        #
        # This method should provide a bulletproof way to detect whether this answer
        # changed if compared with <tt>other</tt>.
        #
        # Returns true/false depending whether this answer is different than <tt>other</tt>.
        property_supported :changed? do |other|
          !unchanged?(other)
        end

        # Public: The opposite of <tt>#changed?</tt>.
        #
        # Returns true/false depending whether this answer is not different than <tt>other</tt>.
        property_supported :unchanged? do |other|
          false
        end

      end

    end
  end
end
