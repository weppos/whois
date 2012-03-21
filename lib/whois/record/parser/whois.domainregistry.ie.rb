#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.domainregistry.ie.rb'


module Whois
  class Record
    class Parser

      #
      # = whois.domainregistry.ie parser
      #
      # Parser for the whois.domainregistry.ie server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisDomainregistryIe < Base
        include Scanners::Ast

        property_supported :status do
          case node("status", &:downcase)
          when nil
            :available
          when "active"
            :registered
          else
            Whois.bug!(ParserError, "Unknown status `#{node("status")}'.")
          end
        end

        property_supported :available? do
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_supported :expires_on do
          node("renewal") { |value| Time.parse(value) }
        end


        property_supported :nameservers do
          Array.wrap(node("nserver")).map do |line|
            name, ipv4 = line.split(/\s+/)
            Record::Nameserver.new(:name => name, :ipv4 => ipv4)
          end
        end


        # Initializes a new {Scanners::WhoisDomainregistryIe} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisDomainregistryIe.new(content_for_scanner).parse
        end

      end

    end
  end
end
