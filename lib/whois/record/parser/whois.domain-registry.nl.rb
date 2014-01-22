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

      # Parser for the whois.domain-registry.nl server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisDomainRegistryNl < Base

        # == Values for Status
        #
        # - free: the .nl domain name is still available for registration
        # - withdrawn: the .nl domain name is barred from registration
        # - excluded: the .nl domain name is excluded from registration
        # - requested: an application for the .nl domain name is being processed
        # - active: the .nl domain name has already been registered. (If you want to know who has registered the name, tick the ‘Extended search’ box. You will then be shown more information about whoever has registered the name.)
        # - inactive: the .nl domain name has already been registered, but has not yet been added to the .nl zone file. (If you want to know who has registered the name, tick the ‘Extended search’ box. You will then be shown more information about whoever has registered the name.)
        # - in quarantine: this .nl domain name's registration has been cancelled. Following cancellation, a domain name is placed in quarantine for forty days.
        #
        # @see https://www.sidn.nl/en/whois/
        # @see https://www.sidn.nl/en/about-nl/whois/looking-up-a-domain-name/
        #
        property_supported :status do
          if content_for_scanner =~ /Status:\s+(.+?)\n/
            case $1.downcase
            when "active"
              :registered
            when "in quarantine"
              :redemption
            when "inactive"
              :inactive
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          status == :available
        end

        property_supported :registered? do
          status != :available
        end


        property_supported :created_on do
          if content_for_scanner =~ /Date registered:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Record last updated:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :expires_on


        property_supported :nameservers do
          if content_for_scanner =~ /Domain nameservers:\n((.+\n)+)\n/
            $1.split("\n").map do |line|
              name, ipv4 = line.strip.split(/\s+/)
              Record::Nameserver.new(:name => name, :ipv4 => ipv4)
            end
          end
        end


        # Checks whether the response has been throttled.
        #
        # @return [Boolean]
        #
        # @example
        #   whois.domain-registry.nl: only 1 request per second allowed, try again later
        #
        # @example
        #   whois.domain-registry.nl: daily whois-limit exceeded
        #
        def response_throttled?
          case content_for_scanner
          when /^#{Regexp.escape("whois.domain-registry.nl: only 1 request per second allowed, try again later")}/
            true
          when /^#{Regexp.escape("whois.domain-registry.nl: daily whois-limit exceeded")}/
            true
          else
            false
          end
        end

        # Checks whether this response contains a message
        # that can be reconducted to a "WHOIS Server Unavailable" status.
        #
        # @return [Boolean]
        def response_unavailable?
          !!(content_for_scanner =~ /Server too busy, try again later/)
        end

      end

    end
  end
end
