#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'


module Whois
  class Answer
    class Parser

      #
      # = whois.meregistry.net parser
      #
      # Parser for the whois.meregistry.net server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisMeregistryNet < Base

        property_supported :status do
          content_for_scanner.scan(/Domain Status:(.*?)\n/).flatten
        end

        property_supported :available? do
          (content_for_scanner.strip == "NOT FOUND")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Domain Create Date:(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Domain Last Updated Date:(.*)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Domain Expiration Date:(.*)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          content_for_scanner.scan(/Nameservers:([^\s]+)\n/).flatten.map do |name|
            Answer::Nameserver.new(name.downcase)
          end
        end

      end

    end
  end
end
