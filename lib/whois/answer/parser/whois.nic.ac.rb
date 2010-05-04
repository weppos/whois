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
      # = whois.nic.ac parser
      #
      # Parser for the whois.nic.ac server.
      #
      class WhoisNicAc < Base

        property_not_supported :disclaimer

        property_supported :domain do
          @domain ||= Proc.new do
            content_for_scanner =~ /Domain "(.*?)"/
            $1.downcase
          end.call
        end

        property_not_supported :domain_id


        property_supported :status do
          @status ||= if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          @available ||= !(content_for_scanner =~ /Not available/)
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_not_supported :registrar

        property_not_supported :registrant_contact

        property_not_supported :admin_contact

        property_not_supported :technical_contact

        # @deprecated
        register_property :registrant, :not_supported
        # @deprecated
        register_property :admin, :not_supported
        # @deprecated
        register_property :technical, :not_supported


        property_not_supported :nameservers


        property_supported :changed? do |other|
          !unchanged?(other)
        end

        property_supported :unchanged? do |other|
          self == other ||
          self.content_for_scanner == other.content_for_scanner
        end

      end

    end
  end
end
