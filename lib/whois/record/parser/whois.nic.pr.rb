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

      # Parser for the whois.nic.pr server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicPr < Base

        property_supported :domain do
          if content_for_scanner =~ /^Domain:\s+(.+)\n/
            $1
          elsif content_for_scanner =~ /^The domain (.+?) is not registered\.\n/
            $1
          end
        end

        property_not_supported :domain_id


        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^The domain (.+?) is not registered\.\n/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created On:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Expires On:\s+(.+)\n/
            Time.parse($1)
          end
        end


        property_not_supported :registrar

        property_not_supported :registrant_contacts

        property_not_supported :admin_contacts

        property_not_supported :technical_contacts


        property_supported :nameservers do
          content_for_scanner.scan(/DNS:\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name)
          end
        end

      end

    end
  end
end
