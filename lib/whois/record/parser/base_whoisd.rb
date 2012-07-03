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

      # Base parser for Whoisd servers.
      #
      # @abstract
      #
      # @since  RELEASE
      class BaseWhoisd < Base
        include Scanners::Ast

        class_attribute :status_mapping
        self.status_mapping = {
          'paid and in zone' => :registered,
          'expired' => :expired,
        }

        property_supported :status do
          node('status') do |string|
            string = string.first if string.is_a?(Array)
            self.class.status_mapping[string.downcase] ||
            Whois.bug!(ParserError, "Unknown status `#{string}'.")
          end || :available
        end

        property_supported :available? do
          !!node('status:available')
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node('registered') { |string| Time.parse(string) }
        end

        property_supported :updated_on do
          node('changed') { |string| Time.parse(string) }
        end

        property_supported :expires_on do
          node('expire') { |string| Time.parse(string) }
        end


        property_supported :registrar do
          node('registrar') do |string|
            Whois::Record::Registrar.new(
                :id           => string,
                :name         => string
            )
          end
        end


        property_supported :nameservers do
          lines = node(node('nsset'))['nserver'] rescue nil
          Array.wrap(lines).map do |line|
            if line =~ /(.+) \((.+)\)/
              name = $1
              ipv4, ipv6 = $2.split(', ')
              Record::Nameserver.new(:name => name, :ipv4 => ipv4, :ipv6 => ipv6)
            else
              Record::Nameserver.new(:name => line.strip)
            end
          end
        end


        # Initializes a new {Scanners::Whoisd} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::Whoisd.new(content_for_scanner).parse
        end

      end

    end
  end
end
