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

        # Returns the registry disclaimer that comes with the answer.
        property_supported :disclaimer do
          @disclaimer ||= nil
        end


        # If available, returns the domain name as stored by the registry.
        property_supported :domain do
          @domain ||= nil
        end

        # If available, returns the unique domain ID set by the registry.
        property_supported :domain_id do
          @domain_id ||= nil
        end


        # Returns the record status or an array of status,
        # in case the registry supports it.
        property_supported :status do
          @staus ||= nil
        end

        # Returns whether this record is available.
        property_supported :available? do
          @available ||= nil
        end

        # Returns whether this record is registered.
        property_supported :registered? do
          @registered ||= nil
        end


        # If available, returns a Time object representing the date
        # the record was created, according to the registry answer.
        property_supported :created_on do
          @created_on ||= nil
        end

        # If available, returns a Time object representing the date
        # the record was last updated, according to the registry answer.
        property_supported :updated_on do
          @updated_on ||= nil
        end

        # If available, returns a Time object representing the date
        # the record is set to expire, according to the registry answer.
        property_supported :expires_on do
          @expires_on ||= nil
        end


        # If available, returns a <tt>Whois::Answer::Registrar</tt> record
        # containing the registrar details extracted from the registry answer.
        property_supported :registrar do
          @registrar ||= nil
        end


        # If available, returns a <tt>Whois::Answer::Contact</tt> record
        # containing the registrant details extracted from the registry answer.
        property_supported :registrant_contact do
          @registrant_contact ||= nil
        end

        # If available, returns a <tt>Whois::Answer::Contact</tt> record
        # containing the admin contact details extracted from the registry answer.
        property_supported :admin_contact do
          @admin_contact ||= nil
        end

        # If available, returns a <tt>Whois::Answer::Contact</tt> record
        # containing the technical contact details extracted from the registry answer.
        property_supported :technical_contact do
          @technical_contact ||= nil
        end


        # If available, returns an array of name servers entries for this domain
        # if any name server is available in the registry answer.
        # Each name server is a lower case string.
        #
        # ==== Examples
        #
        #   nameserver
        #   # => []
        #   nameserver
        #   # => ["ns2.google.com", "ns1.google.com", "ns3.google.com"]
        #
        property_supported :nameservers do
          @nameservers ||= []
        end


        # Returns whether this answer changed compared to <tt>other</tt>.
        #
        # Comparing the Answer contents is not always as trivial as it seems.
        # Whois servers sometimes inject dynamic method into the whois answer such as
        # the timestamp the request was generated.
        # This causes two answers to be different even if they actually should be considered equal
        # because the registry data didn't change.
        #
        # This method should provide a bulletproof way to detect whether this answer
        # changed if compared with <tt>other</tt>.
        property_supported :changed? do |other|
          !unchanged?(other)
        end

        # The opposite of <tt>changed?</tt>.
        property_supported :unchanged? do |other|
          false
        end

      end

    end
  end
end
