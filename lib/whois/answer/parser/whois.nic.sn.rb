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
          if registered? and content_for_scanner =~ /Domain:\s+(.*)\n/
            $1
          elsif available? and content_for_scanner =~ /Domain (.+?) not found/
            $1
          end
        end

        property_not_supported :domain_id


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /Domain (.+?) not found/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :registrar do
          if content_for_scanner =~ /Registrar:\s+(.*)\n/
            Whois::Answer::Registrar.new(:id => $1, :name => $1)
          end
        end


        property_supported :registrant_contacts do
          if content_for_scanner =~ /Owner's handle:\s+(.+)\n/
            contact($1, Whois::Answer::Contact::TYPE_REGISTRANT)
          end
        end

        property_supported :admin_contacts do
          if content_for_scanner =~ /Administrative Contact's handle:\s+(.*+)\n/
            contact($1, Whois::Answer::Contact::TYPE_ADMIN)
          end
        end

        property_supported :technical_contacts do
          if content_for_scanner =~ /Technical Contact's handle:\s+(.+)\n/
            contact($1, Whois::Answer::Contact::TYPE_TECHNICAL)
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/Nameserver:\s+(.+)\n/).flatten.map do |name|
            Answer::Nameserver.new(name)
          end
        end


        private

          def contact(string, type)
            Whois::Answer::Contact.new(:type => type, :id => string, :name => string)
          end

      end

    end
  end
end
