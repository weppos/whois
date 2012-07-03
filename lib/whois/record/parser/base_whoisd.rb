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
          if content_for_scanner =~ /status:\s+(.+)\n/
            self.class.status_mapping[$1.downcase] ||
            Whois.bug!(ParserError, "Unknown status `#{$1}'.")
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^%ERROR:101: no entries found/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /registered:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /changed:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /expire:\s+(.+?)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          if content_for_scanner =~ /registrar:\s+(.+)\n/
            Whois::Record::Registrar.new(
                :id           => $1,
                :name         => $1
            )
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |line|
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
