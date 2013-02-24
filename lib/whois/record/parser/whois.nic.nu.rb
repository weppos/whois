#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      #
      # = whois.nic.nu
      #
      # Parser for the whois.nic.nu server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      # @author Simone Carletti <weppos@weppos.net>
      # @author Mikkel Kristensen <mikkel@tdx.dk>
      #
      class WhoisNicNu < Base


        # == Values for Status
        #
        # @see http://www.nic.nu/about/about5.pdf
        #
        property_supported :status do
          if content_for_scanner =~ /Record status:\s+(.*)\n/
            case $1.downcase
            when "active"     then :registered
            # The day after the domain name expires, its status is changed to "Not Renewed",
            # but it is still available for you to renew during another fourweek period.
            # After this expiration reprieve, the name is put up for shortterm auction.
            # If no one registers the name via the auction, it expires and becomes available
            # to the general public for  registration using the standard process.
            when "notrenewed" then :redemption
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /NO MATCH for domain/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Record created on (.+?).\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Record last updated on (.+?).\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Record expires on (.+?).\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Domain servers in listed order:(.*)Owner and Administrative Contact information for domains/m
            $1.split.map do |name|
              Record::Nameserver.new(:name => name)
            end
          end
        end

      end

    end
  end
end
