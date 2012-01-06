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

        # @see http://dnc.org.nz/content/srs-whois-spec-1.0.html
        property_supported :status do
          if content_for_scanner =~ /query_status:\s(.+)\n/
            case s = $1.downcase
              when /active/               then :registered
              when /available/            then :available
              when /invalid characters/   then :invalid
              # The domain is no longer active but is in the period prior
              # to being released for general registrations
              when "210 pendingrelease"   then :redemption
              else
                Whois.bug!(ParserError, "Unknown status `#{s}'.")
            end
          else
            Whois.bug!(ParserError, "Unable to parse status.")
          end
        end

        property_supported :available? do
          (status == :available)
        end

        property_supported :registered? do
          (status == :registered) || (status == :redemption)
        end


        property_supported :created_on do
          if content_for_scanner =~ /domain_dateregistered:\s(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /domain_datelastmodified:\s(.+)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /domain_datebilleduntil:\s(.+)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/ns_name_[\d]+:\s(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(name)
          end
        end


        # NEWPROPERTY
        def valid?
          cached_properties_fetch(:valid?) do
            !invalid?
          end
        end

        # NEWPROPERTY
        def invalid?
          cached_properties_fetch(:invalid?) do
            status == :invalid
          end
        end

      end

    end
  end
end
