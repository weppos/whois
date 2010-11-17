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
      # = whois.co.pl parser
      #
      # Parser for the whois.co.pl server.
      #
      class WhoisCoPl < Base

        property_not_supported :disclaimer


        property_supported :domain do
          @domain ||= if content_for_scanner =~ /domain:\s+(.+?)\n/
            $1
          end
        end

        property_not_supported :domain_id


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          @status ||= if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          @available ||=  !!(content_for_scanner =~ /^% Unfortunately, No Results Were Found/)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          @updated_on ||= if content_for_scanner =~ /changed:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_not_supported :expires_on


        property_not_supported :registrar


        property_not_supported :registrant_contact

        property_not_supported :admin_contact

        property_not_supported :technical_contact


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten
        end


        # NEWPROPERTY
        property_supported :changed? do |other|
          !unchanged?(other)
        end

        # NEWPROPERTY
        property_supported :unchanged? do |other|
          (self === other) ||
          (self.content == other.content)
        end

      end

    end
  end
end
