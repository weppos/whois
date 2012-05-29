#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.ua server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @since 2.4.0
      class WhoisUa < Base

        property_supported :status do
          if content_for_scanner =~ /status:\s+(.+?)\n/
            case s = $1.downcase
              when /^ok-until/
                :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{s}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No entries found for domain/)
        end

        property_supported :registered? do
          !available?
        end

				property_supported :domain do
					if content_for_scanner =~ /domain:\s+(.+)\n/
						$1
					end
        end

				property_not_supported :domain_id
				
				property_not_supported :referral_whois
				
				property_not_supported :referral_url
				
        property_not_supported :created_on

        property_supported :updated_on do
          if content_for_scanner =~ /changed:\s+(.+)\n/
            time = $1.split(" ").last
            Time.parse(time)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /status:\s+(.+)\n/
            time = $1.split(" ").last
            Time.parse(time)
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name.strip.downcase)
          end
        end

      end

    end
  end
end
