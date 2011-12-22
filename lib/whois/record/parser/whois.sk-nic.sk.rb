#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      #
      # = whois.sk-nic.sk parser
      #
      # Parser for the whois.sk-nic.sk server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisSkNicSk < Base

        # == Status responses:
        #
        # @see https://www.sk-nic.sk/documents/stavy_domen.html
        # @see http://www.inwx.de/en/sk-domain.html
        #
        property_supported :status do
          if content_for_scanner =~ /^Domain-status\s+(.+)\n/
            case $1.downcase
              when  "dom_ok",   # The domain is registered and paid.
                    "dom_ta",   # The domain is registered and registration fee has to be payed (14 days).
                                # Replacement 14-day period for domain payment.
                    "dom_dakt", # 28 days before the expiration of one year's notice is sent to the first call for an extension of domains.
                                # The domain is still fully functional (14 days).
                    "dom_warn", # 14 days before the expiration of one year's notice is sent to the second call to the extension of domains.
                                # The domain is still fully functional (14 days).
                    "dom_lnot", # The domain is expired and has not been renewed (14 days).
                    "dom_exp"
                :registered
              when  "dom_held"  # The domain losts its registrar (28 days).
                :redemption
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^Not found/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          if content_for_scanner =~ /^Last-update\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /^Valid-date\s+(.+)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/dns_name\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(name)
          end
        end

      end

    end
  end
end
