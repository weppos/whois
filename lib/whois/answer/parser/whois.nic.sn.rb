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
      # = whois.nic.sn parser
      #
      # Parser for the whois.nic.sn server.
      #
      class WhoisNicSn < Base

        property_not_supported :disclaimer

        property_supported :domain do
          @domain ||= if registered? and content_for_scanner =~ /Domain:\s+(.*)\n/
            $1
          elsif available? and content_for_scanner =~ /Domain (.+?) not found/
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
          @available ||= !!(content_for_scanner =~ /Domain (.+?) not found/)
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_supported :created_on do
          @created_on ||= if content_for_scanner =~ /Created:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :registrar do
          @registrar ||= if content_for_scanner =~ /Registrar:\s+(.*)\n/
            Whois::Answer::Registrar.new(:id => $1, :name => $1)
          end
        end


        property_supported :registrant_contact do
          @registrant_contact ||= if content_for_scanner =~ /Owner's handle:\s+(.*)\n/
            contact($1)
          end
        end

        property_supported :admin_contact do
          @admin_contact ||= if content_for_scanner =~ /Administrative Contact's handle:\s+(.*)\n/
            contact($1)
          end
        end

        property_supported :technical_contact do
          @technical_contact ||= if content_for_scanner =~ /Technical Contact's handle:\s+(.*)\n/
            contact($1)
          end
        end


        property_supported :nameservers do
          @nameservers ||= content_for_scanner.scan(/Nameserver:\s+(.+)\n/).flatten
        end


        property_supported :changed? do |other|
          !unchanged?(other)
        end

        property_supported :unchanged? do |other|
          (self.equal? other) ||
          (self.content == other.content)
        end


        private

          def contact(string)
            Whois::Answer::Contact.new(:id => string, :name => string)
          end

      end

    end
  end
end
