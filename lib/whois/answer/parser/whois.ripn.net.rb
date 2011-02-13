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
      # = whois.ripn.net parser
      #
      # Parser for the whois.ripn.net server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisRipnNet < Base

        property_supported :status do
          if content_for_scanner =~ /state:\s+(.+?)\n/
            $1.split(",").map(&:strip)
          else
            []
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No entries found/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /created:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /paid-till:\s+(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :registrar do
          @registrar ||= if content_for_scanner =~ /registrar:\s+(.*)\n/
            Answer::Registrar.new(:id => $1)
          end
        end

        property_supported :admin_contact do
          @admin_contact ||= Answer::Contact.new(
            :type         => Answer::Contact::TYPE_ADMIN,
            :name         => content_for_scanner[/person:\s+(.+)\n/, 1],
            :organization => content_for_scanner[/org:\s+(.+)\n/, 1],
            :phone        => content_for_scanner[/phone:\s+(.+)\n/, 1],
            :fax          => content_for_scanner[/fax-no:\s+(.+)\n/, 1],
            # Return the first matched email, even if there are a few of them
            :email        => content_for_scanner[/e-mail:\s+(.+)\n/, 1],
          )
        end

        # Nameservers are listed in the following formats:
        # 
        #   nserver:     ns.masterhost.ru.
        #   nserver:     ns.masterhost.ru. 217.16.20.30
        # 
        # In both cases, always return only the name.
        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map { |value| value.split(" ").first.chomp(".") }
        end

      end

    end
  end
end
