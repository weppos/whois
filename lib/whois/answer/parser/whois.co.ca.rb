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
      # = whois.co.ca parser
      #
      # Parser for the whois.co.ca server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisCoCa < Base

        property_supported :status do
          @status ||= case
            when available? then :available
            when reserved?  then :reserved
            else                 :registered
          end
        end

        property_supported :available? do
          @available  ||= !!(content_for_scanner =~ /^(.+) is available/)
        end

        property_supported :registered? do
          @registered ||= !(available? || reserved?)
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /date_approved:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /date_renewal:\s+(.+)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/ns[\d]_hostname:\s+(.+)\n/).flatten
        end


        # NEWPROPERTY
        def reserved?
          !!(content_for_scanner =~ /^Domain is not available or is reserved by the registry/)
        end

      end

    end
  end
end
