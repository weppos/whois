#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
# Copyright (c) 2012 SophosLabs http://www.sophos.com
#++
require 'pp'
require 'whois/record/parser/base'

module Whois
  class Record
    class Parser

      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @since 2.4.0 
      # The original was 'whois.dotster.com'
      class WhoisDomainCom < Base
        property_not_supported :status 
        # The server is contacted only in case of a registered domain.
        property_supported :available? do
          false
        end

        property_supported :registered? do
          !available?
        end

        property_supported :created_on do
          if content_for_scanner =~ /Created on: (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Last Updated on: (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expires on: (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :registrar do
          Record::Registrar.new(
            :name => "DOMAIN.COM, LLC",
            :organization => "DOMAIN.COM, LLC",
            :url  => "http://www.domain.com"
          )
        end

        #Registrant:
        #   WeAreInside.com
        #   Rio Canamares, 2 of. 2
        #   Alcala de Henares, Madrid  28804
        #   ES
        #
        #   Registrar: DOMAIN
        #   Domain Name: ILOCALIS.COM
        #      Created on: 22-OCT-08
        #      Expires on: 22-OCT-13
        #      Last Updated on: 18-OCT-10
        #
        #   Administrative, Technical Contact:
        #      Calatrava, Antonio  iphoneutilities@antoniocalatrava.com
        #      WeAreInside.com
        #      Rio Canamares, 2 of. 2
        #      Alcala de Henares, Madrid  28804
        #      ES
        #      +34918802919
        #      +34918802919
        #
        #
        #   Domain servers in listed order:
        #      NS1.MYDOMAIN.COM 
        #      NS2.MYDOMAIN.COM 
        #      NS3.MYDOMAIN.COM 
        #      NS4.MYDOMAIN.COM 
        #
        #End of Whois Information

        property_supported :registrant_contacts do
          match = content_for_scanner.slice(/^Registrant:\n((.+\n)+)\n/, 1)
          contents = match.split("\n").map(&:strip)
          return nil if contents.nil? or contents.length < 4

          name = contents[0]
          country = contents[-1]
          city, state_zip = contents[-2].split(",")
          state, zip = state_zip.strip.split(/\s+/) unless state_zip.nil?
          # No zip code - 'state' looks like a code
          if zip.nil? and !state.nil? and state =~/\d/
            zip = state
            state = nil
          end
          address = contents[1..-3].join(" ")
          Record::Contact.new(
            :type         => Record::Contact::TYPE_REGISTRANT,
            :name         => name,
            :organization => nil,
            :address      => address,
            :city         => city,
            :state        => state,
            :zip          => zip,
            :country_code => country,
            :email        => nil,
            :phone        => nil,
            :fax          => nil
          )
        end

        # TODO: admin and technical contacts could have multiple formats
        # see domain: GAZIANTEPHABERLER.COM and COCONUTSCRUBS.COM for differences
        property_not_supported :admin_contacts 
        property_not_supported :technical_contacts 

      end

    end
  end
end





