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
      # = whois.cira.ca parser
      #
      # Parser for the whois.cira.ca server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisCiraCa < Base

        property_supported :status do
          if content_for_scanner =~ /Domain status:\s+(.+?)\n/
            case $1.downcase
            when "registered"
              :registered
            when "redemption"
              :registered
            when "auto-renew grace"
              :registered
            when "to be released"
              :registered
            when "available"
              :available
            when "unavailable"
              :invalid
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            Whois.bug!(ParserError, "Unable to parse status.")
          end
        end

        property_supported :available? do
          status == :available
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Creation date:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Updated date:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expiry date:\s+(.+?)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          if content_for_scanner =~ /^Registrar:\n(.+\n?)^\n/m
            match = $1
            id    = match =~ /Number:\s+(.+)$/ ? $1.strip : nil
            name  = match =~ /Name:\s+(.+)$/   ? $1.strip : nil
            Whois::Record::Registrar.new(:id => id, :name => name, :organization => name)
          end
        end


        # Nameservers are listed in the following formats:
        #
        #   ns1.google.com
        #   ns2.google.com
        #
        #   ns1.google.com  216.239.32.10
        #   ns2.google.com  216.239.34.10
        #
        property_supported :nameservers do
          if content_for_scanner =~ /Name servers:\n((?:\s+([^\s]+)\s+([^\s]+)\n)+)/
            $1.split("\n").map do |line|
              name, ipv4 = line.strip.split(/\s+/)
              Record::Nameserver.new(:name => name, :ipv4 => ipv4)
            end
          end
        end


        # Attempts to detect and returns the
        # schema version.
        #
        # TODO: This is very empiric.
        #       Use the available status in combination with the creation date label.
        def schema
          @schema ||= if content_for_scanner =~ /^% \(c\) (.+?) Canadian Internet Registration Authority/
            case $1
            when "2007" then "1"
            when "2010" then "2"
            end
          end
          @schema || Whois.bug!(ParserError, "Unable to detect schema version.")
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
