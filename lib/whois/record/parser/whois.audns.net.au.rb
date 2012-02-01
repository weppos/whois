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
      # = whois.audns.net.au parser
      #
      # Parser for the whois.audns.net.au server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisAudnsNetAu < Base

        # == Values for Status
        #
        # @see http://www.auda.org.au/policies/auda-2002-28/
        # @see http://www.auda.org.au/policies/auda-2006-07/
        #
        property_supported :status do
          content_for_scanner.scan(/Status:\s+(.+?)\n/).flatten
        end

        property_supported :available? do
          (content_for_scanner.strip == "No Data Found")
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          if content_for_scanner =~ /Last Modified:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :expires_on


        property_supported :nameservers do
          content_for_scanner.scan(/Name Server:\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(name)
          end
        end

      end

    end
  end
end
