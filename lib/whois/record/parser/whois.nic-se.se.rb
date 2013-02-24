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
      # = whois.nic-se.se
      #
      # Parser for the whois.nic-se.se server.
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
      class WhoisNicSeSe < Base

        property_supported :status do
          # Two keys available: state and status.
          if content_for_scanner =~ /status:\s+(.+?)\n/
            case $1.downcase
              when "ok" then :registered
              when "inactive" then :inactive
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /" not found./)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /created:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /expires:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /modified:\s+(.+)\n/
            Time.parse($1) unless $1 == '-'
          end
        end


        # Nameservers are listed in the following formats:
        #
        #   nserver:  ns2.loopia.se
        #   nserver:  ns2.loopia.se 93.188.0.21
        #
        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |line|
            name, ipv4 = line.split(/\s+/)
            Record::Nameserver.new(:name => name, :ipv4 => ipv4)
          end
        end

      end

    end
  end
end
