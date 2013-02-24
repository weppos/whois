#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.srs.net.nz server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisSrsNetNz < Base

        # @see http://dnc.org.nz/content/srs-whois-spec-1.0.html
        property_supported :status do
          if content_for_scanner =~ /query_status:\s(.+)\n/
            case (s = $1.downcase)
            when "200 active"
              :registered
            # The domain is no longer active but is in the period prior
            # to being released for general registrations
            when "210 pendingrelease"
              :redemption
            when "220 available"
              :available
            when "404 request denied"
              :error
            when /invalid characters/
              :invalid
            else
              Whois.bug!(ParserError, "Unknown status `#{s}'.")
            end
          else
            Whois.bug!(ParserError, "Unable to parse status.")
          end
        end

        property_supported :available? do
          status == :available
        end

        property_supported :registered? do
          status == :registered || status == :redemption
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
            Record::Nameserver.new(:name => name)
          end
        end


        # Checks whether the response has been throttled.
        #
        # @return [Boolean]
        #
        # @example
        #   query_status: 440 Request Denied
        #
        def response_throttled?
          cached_properties_fetch(:response_throttled?) do
            !!(content_for_scanner =~ /^query_status: 440 Request Denied/)
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
