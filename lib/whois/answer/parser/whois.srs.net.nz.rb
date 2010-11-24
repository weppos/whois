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
      # = whois.srs.net.nz parser
      #
      # Parser for the whois.srs.net.nz server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisSrsNetNz < Base

        property_supported :status do
          @status ||= if content_for_scanner =~ /query_status:\s(.+)\n/
            case $1.downcase
              when /active/               then :registered
              when /available/            then :available
              when /invalid characters/   then :invalid
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
          @registered ||= (status == :registered)
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /domain_dateregistered:\s(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /domain_datelastmodified:\s(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /domain_datebilleduntil:\s(.+)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/ns_name_[\d]+:\s(.+)\n/).flatten
        end

      end

    end
  end
end
