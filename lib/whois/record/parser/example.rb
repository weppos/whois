#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.example.com server.
      #--
      # In case you are not implementing all the methods,
      # please add the following statement to the class docblock.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      # ++
      class Example < Base

        # Gets the registry disclaimer that comes with the record.
        #
        # Returns a String with the disclaimer if available,
        # <tt>nil</tt> otherwise.
        property_supported :disclaimer do
          nil
        end


        # Gets the domain name as stored by the registry.
        #
        # Returns a String with the domain name if available,
        # <tt>nil</tt> otherwise.
        property_supported :domain do
          nil
        end

        # Gets the unique domain ID as stored by the registry.
        #
        # Returns a String with the domain ID if available,
        # <tt>nil</tt> otherwise.
        property_supported :domain_id do
          nil
        end


        # Gets the record status or statuses.
        #
        # Returns a String/Array with the record status if available,
        # <tt>nil</tt> otherwise.
        property_supported :status do
          nil
        end

        # Checks whether this record is available.
        #
        # Returns true/false depending whether this record is available.
        property_supported :available? do
          nil
        end

        # Checks whether this record is registered.
        #
        # Returns true/false depending this record is available.
        property_supported :registered? do
          nil
        end


        # Gets the date the record was created,
        # according to the registry record.
        #
        # Returns a Time object representing the date the record was created or
        # <tt>nil</tt> otherwise.
        property_supported :created_on do
          nil
        end

        # Gets the date the record was last updated,
        # according to the registry record.
        #
        # Returns a Time object representing the date the record was last updated or
        # <tt>nil</tt> if not available.
        property_supported :updated_on do
          nil
        end

        # Gets the date the record is set to expire,
        # according to the registry record.
        #
        # Returns a Time object representing the date the record is set to expire or
        # <tt>nil</tt> if not available.
        property_supported :expires_on do
          nil
        end


        # Gets the registrar object containing the registrar details
        # extracted from the registry record.
        #
        # Returns an instance of <tt>Whois::Record::Registrar</tt> representing the registrar or
        # <tt>nil</tt> if not available.
        property_supported :registrar do
          nil
        end


        # Gets the registrant contact object containing the details of the record owner
        # extracted from the registry record.
        #
        # Returns an instance of <tt>Whois::Record::Contact</tt> representing the registrant contact or
        # <tt>nil</tt> if not available.
        property_supported :registrant_contacts do
          nil
        end

        # Gets the administrative contact object containing the details of the record administrator
        # extracted from the registry record.
        #
        # Returns an instance of <tt>Whois::Record::Contact</tt> representing the administrative contact or
        # <tt>nil</tt> if not available.
        property_supported :admin_contacts do
          nil
        end

        # Gets the technical contact object containing the details of the technical representative
        # extracted from the registry record.
        #
        # Returns an instance of <tt>Whois::Record::Contact</tt> representing the technical contact or
        # <tt>nil</tt> if not available.
        property_supported :technical_contacts do
          nil
        end


        # Gets the list of name server entries for this record,
        # extracted from the registry record.
        #
        # @example
        #   nameserver
        #   # => []
        #
        # @example
        #   nameserver
        #   # => [
        #   #     #<struct Whois::Record::Nameserver name="ns1.google.com">,
        #   #     #<struct Whois::Record::Nameserver name="ns2.google.com">
        #   #    ]
        #
        # @return [Array<Whois::Record::Nameserver>]
        property_supported :nameservers do
          []
        end

      end

    end
  end
end
