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
      # = whois.nic.md parser
      #
      # Parser for the whois.nic.md server.
      #
      class WhoisNicMd < Base

        property_not_supported :disclaimer


        property_supported :domain do
          @domain ||= if content_for_scanner =~ /Domain name:\s(.+?)\n/
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
          @available  ||= !!(content_for_scanner.strip == "No match for")
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /Created:\s(.+?)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          @expires_on ||= if content_for_scanner =~ /Expiration date:\s+(.+?)\n/
            Time.parse($1)
          end
        end


        property_not_supported :registrar


        property_supported :registrant_contact do
          @registrant_contact ||= if content_for_scanner =~ /Registrant:\s+(.+?)\n/
            Whois::Answer::Contact.new(
              nil,
              Whois::Answer::Contact::TYPE_REGISTRANT,
              $1
            )
          end
        end

        property_not_supported :admin_contact

        property_not_supported :technical_contact


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/Name server:\s(.+?)\n/).flatten.map { |value| value.split(" ").first }
        end

      end

    end
  end
end
