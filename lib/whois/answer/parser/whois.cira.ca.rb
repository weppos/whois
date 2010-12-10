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
      # = whois.cira.ca parser
      #
      # Parser for the whois.cira.ca server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisCiraCa < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /Domain status:\s+(.*?)\n/
            case $1.downcase
              # schema-2
              when "registered"       then :registered
              when "redemption"       then :registered
              when "auto-renew grace" then :registered
              when "available"        then :available
              # schema-1
              when "exist"      then :registered
              when "avail"      then :available
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            Whois.bug!(ParserError, "Unable to parse status.")
          end
        end

        property_supported :available? do
          @available  ||= (status == :available)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_supported :created_on do
          # schema-2
          @created_on ||= if content_for_scanner =~ /Creation date:\s+(.*?)\n/
            Time.parse($1)
          # schema-1
          elsif content_for_scanner =~ /Approval date:\s+(.*?)\n/
            Time.parse($1)
          end
        end

        # TODO: Not supported in schema-2?
        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /Updated date:\s+(.*?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          # schema-2
          @expires_on ||= if content_for_scanner =~ /Expiry date:\s+(.*?)\n/
            Time.parse($1)
          # schema-1
          elsif content_for_scanner =~ /Renewal date:\s+(.*?)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          @registrar ||= if content_for_scanner =~ /^Registrar:\n(.*\n?)^\n/m
            match = $1
            id    = match =~ /Number:\s+(.*)$/ ? $1.strip : nil
            name  = match =~ /Name:\s+(.*)$/   ? $1.strip : nil
            Whois::Answer::Registrar.new(:id => id, :name => name, :organization => name)
          end
        end


        property_supported :nameservers do
          @nameservers ||= if content_for_scanner =~ /Name servers:\n((?:\s+([^\s]+)\s+([^\s]+)\n)+)/
            $1.split("\n").map { |value| value.split(" ").first }
          else
            []
          end
        end


        # Attempts to detect and returns the
        # schema version.
        def schema
          @schema ||= if content_for_scanner =~ /^% \(c\) (.+?) Canadian Internet Registration Authority/
            case $1
            when "2007" then "1"
            when "2010" then "2"
            end
          end
          @schema || Whois.bug!(ParserError, "Unable to detect schema version.")
        end

      end

    end
  end
end
