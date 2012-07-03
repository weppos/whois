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

      # Parser for the whois.nic.fo server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      # 
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @since  RELEASE
      class WhoisNicFo < BaseWhoisd

        property_not_supported :registrar

        # whois.nif.fo is using an old whoisd version.
        property_supported :nameservers do
          Array.wrap(node('nserver')).map do |line|
            Record::Nameserver.new(:name => line.strip)
          end
        end

      end

    end
  end
end
