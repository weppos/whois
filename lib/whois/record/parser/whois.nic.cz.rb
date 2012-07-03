#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_whoisd'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.cz server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      # 
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicCz < BaseWhoisd

        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |line|
            if line =~ /(.+) \((.+)\)/
              name = $1
              ipv4, ipv6 = $2.split(", ")
              Record::Nameserver.new(:name => name, :ipv4 => ipv4, :ipv6 => ipv6)
            else
              Record::Nameserver.new(:name => line.strip)
            end
          end
        end

      end

    end
  end
end
