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
      # = whois.domain-registry.nl parser
      #
      # Parser for the whois.domain-registry.nl server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisDomainRegistryNl < Base

        property_supported :status do
          if content_for_scanner =~ /Status:\s+(.*?)\n/
            case $1.downcase
              when "active"         then :registered
              when "in quarantine"  then :quarantine
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          (status == :available)
        end

        property_supported :registered? do
          [:registered, :quarantine].include?(status)
        end


        property_supported :created_on do
          if content_for_scanner =~ /Date registered:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Record last updated:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :expires_on


        property_supported :nameservers do
          if content_for_scanner =~ /Domain nameservers:\n((.+\n)+)\n/
            $1.split("\n").map do |line|
              name, ipv4 = line.strip.split(/\s+/)
              Answer::Nameserver.new(name, ipv4)
            end
          end || []
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
        def throttled?
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
