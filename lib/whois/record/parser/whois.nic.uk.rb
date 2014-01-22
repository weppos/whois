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

      # Parser for the whois.nic.uk server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see http://www.nominet.org.uk/other/whois/detailedinstruct/
      #
      class WhoisNicUk < Base

        # == Values for Status
        #
        # @see http://www.nominet.org.uk/registrars/systems/data/regstatus/
        # @see http://www.nominet.org.uk/registrants/maintain/renew/status/
        #
        property_supported :status do
          if content_for_scanner =~ /\s+Registration status:\s+(.+?)\n/
            case $1.downcase
            when "registered until expiry date."
              :registered
            when "registration request being processed."
              :registered
            when "renewal request being processed."
              :registered
            when "no longer required"
              :registered
            when "no registration status listed."
              :reserved
            # NEWSTATUS (redemption?)
            when "renewal required."
              :registered
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          elsif invalid?
            :invalid
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /This domain name has not been registered/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /\s+Registered on:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /\s+Last updated:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /\s+Expiry date:\s+(.+)\n/
            Time.parse($1)
          end
        end


        # @see http://www.nic.uk/other/whois/instruct/
        property_supported :registrar do
          if content_for_scanner =~ /Registrar:\n((.+\n)+)\n/
            content = $1.strip
            id = name = org = url = nil
            
            if content =~ /Tag =/
              name, id = (content =~ /(.+) \[Tag = (.+)\]/) && [$1.strip, $2.strip]
              org, name = name.split(" t/a ")
              url = (content =~ /URL: (.+)/) && $1.strip
            elsif content =~ /This domain is registered directly with Nominet/
              name  = "Nominet"
              org   = "Nominet UK"
              url   = "http://www.nic.uk/"
            end

            Record::Registrar.new(
              :id           => id,
              :name         => name || org,
              :organization => org,
              :url          => url
            )
          end
        end


        property_supported :registrant_contacts do
          if content_for_scanner =~ /Registrant's address:\n((.+\n)+)\n/
            lines = $1.split("\n").map(&:strip)
            address = lines[0..-5]
            city    = lines[-4]
            state   = lines[-3]
            zip     = lines[-2]
            country = lines[-1]
            
            Record::Contact.new(
              :type => Record::Contact::TYPE_REGISTRANT,
              :name => content_for_scanner[/Registrant:\n\s*(.+)\n/, 1],
              :address => address.join("\n"),
              :city => city,
              :state => state,
              :zip => zip,
              :country => country
            )
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Name servers:\n((.+\n)+)\n/
            $1.split("\n").reject { |value| value =~ /No name servers listed/ }.map do |line|
              name, ipv4, ipv6 = line.strip.split(/\s+/)
              Record::Nameserver.new(:name => name, :ipv4 => ipv4, :ipv6 => ipv6)
            end
          end
        end


        # Checks whether the response has been throttled.
        #
        # @return [Boolean]
        #
        # @example
        #   The WHOIS query quota for 127.0.0.1 has been exceeded
        #   and will be replenished in 50 seconds.
        #
        def response_throttled?
          !!(content_for_scanner =~ /The WHOIS query quota for .+ has been exceeded/)
        end


        # NEWPROPERTY
        def valid?
          cached_properties_fetch(:valid?) do
            !invalid?
          end
        end

        # NEWPROPERTY
        def invalid?
          cached_properties_fetch(:invalid?) do
            !!(content_for_scanner =~ /This domain cannot be registered/)
          end
        end

        # NEWPROPERTY
        # def suspended?
        # end

      end

    end
  end
end
