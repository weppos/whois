#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      #
      # = whois.registry.hm parser
      #
      # Parser for the whois.registry.hm server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisRegistryHm < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^Domain not found/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Domain creation date: (.+?)\n/
            # Change dd/mm/yy to yyyy-mm-dd to prevent
            # argument out of range
            Time.parse($1.split("/").reverse.join("-"))
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Domain expiration date: (.+?)\n/
            Time.parse($1.split("/").reverse.join("-"))
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/Name Server: ([^\s]+)\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name.downcase)
          end
        end

      end

    end
  end
end
