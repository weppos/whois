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
      # = whois.tonic.to parser
      #
      # Parser for the whois.tonic.to server.
      #
      class WhoisTonicTo < Base

        property_not_supported :disclaimer


        property_not_supported :domain

        property_not_supported :domain_id


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          if response_incomplete?
            :incomplete
          else
            if available?
              :available
            else
              :registered
            end
          end
        end

        property_supported :available? do
           (!response_incomplete? && !!(content_for_scanner =~ /No match for/))
        end

        property_supported :registered? do
          (!response_incomplete? && !available?)
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_not_supported :registrar


        property_not_supported :registrant_contact

        property_not_supported :admin_contact

        property_not_supported :technical_contact


        property_not_supported :nameservers


        # Very often the .to server returns a partial response,
        # which is a response containing an empty line.
        # It seems to be a very poorly-designed throttle mechanism.
        #
        # @return [Boolean]
        #
        # @see Whois::Answer::Parser::Base#response_incomplete?
        #
        def response_incomplete?
          content_for_scanner.strip == ""
        end


        protected

          def incomplete_response?
            Whois.deprecate "#{self.class}#response_incomplete? will be removed in Whois 2.1. Please use #{self.class}#response_incomplete?."
            response_incomplete?
          end

      end

    end
  end
end
