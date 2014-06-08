#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_cocca'


module Whois
  class Record
    class Parser

      # Parser for the whois.je server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisJe < BaseCocca

        class_attribute :status_mapping

        self.status_mapping = {
          "active" => :registered,
          "delegated" => :registered,
          "not registered" => :available,
          "available" => :available,
          "serverdeleteprohibited" => :registered,
          "serverupdateprohibited" => :registered,
          "servertransferprohibited" => :registered,
          "ok" => :registered,
        }

        property_supported :domain do
          content_for_scanner =~ /Domain Name:\s+(.+?)\n/
          $1 || Whois.bug!(ParserError, "Unable to parse domain.")
        end

        property_supported :status do
          if content_for_scanner =~ /Domain Status:\s+(.+?)\n/
            status = $1.downcase
            self.class.status_mapping[status] || Whois.bug!(ParserError, "Unknown status `#{status}'.")
          else
            Whois.bug!(ParserError, "Unable to parse status.")
          end
        end

        property_supported :created_on do
          if content_for_scanner =~ /Creation Date:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :nameservers do
          content_for_scanner.scan(/Name Server:\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name.downcase)
          end
        end

      end

    end
  end
end
