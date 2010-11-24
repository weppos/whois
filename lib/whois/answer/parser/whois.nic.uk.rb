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
      # = whois.nic.uk parser
      #
      # Parser for the whois.nic.uk server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      # @see http://www.nominet.org.uk/other/whois/detailedinstruct/
      #
      class WhoisNicUk < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /\s+Registration status:\s+(.+?)\n/
            case $1.downcase
              when "registered until renewal date."         then :registered
              when "registration request being processed."  then :registered
              when "renewal request being processed."       then :registered
              # NEWSTATUS
              when "renewal required."                      then :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          @available  ||= !!(content_for_scanner =~ /This domain name has not been registered/)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /\s+Registered on:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /\s+Last updated:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /\s+Renewal date:\s+(.*)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= if content_for_scanner =~ /Name servers:\n((.+\n)+)\n/
            $1.split("\n").
              reject { |value| value =~ /No name servers listed/ }.
              map { |value| value.strip.split(/\s+/).first }
          else
            []
          end
        end


        # NEWPROPERTY
        def valid?
          @valid ||= !invalid?
        end

        # NEWPROPERTY
        def invalid?
          @invalid ||= !!(content_for_scanner =~ /This domain cannot be registered/)
        end

        # NEWPROPERTY
        # def suspended?
        # end

      end

    end
  end
end
