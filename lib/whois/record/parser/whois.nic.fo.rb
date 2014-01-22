#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_whoisd'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.fo server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicFo < BaseWhoisd

        property_not_supported :registrar

        # whois.nic.fo is using an old whoisd version.
        property_supported :technical_contacts do
          node('tech-c') do |value|
            build_contact(value, Record::Contact::TYPE_TECHNICAL)
          end
        end


        # whois.nic.fo is using an old whoisd version.
        property_supported :nameservers do
          Array.wrap(node('nserver')).map do |line|
            Record::Nameserver.new(:name => line.strip)
          end
        end

      end

    end
  end
end
