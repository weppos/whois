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
require 'whois/answer/parser/scanners/whoisbiz'


module Whois
  class Answer
    class Parser

      #
      # = whois.biz parser
      #
      # Parser for the whois.biz server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisBiz < Base
        include Features::Ast


        property_supported :status do
          node("Domain Status")
        end

        property_supported :available? do
          !!node("status-available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Domain Registration Date") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          node("Domain Last Updated Date") { |value| Time.parse(value) }
        end

        property_supported :expires_on do
          node("Domain Expiration Date") { |value| Time.parse(value) }
        end


        property_supported :nameservers do
          node("Name Server") do |values|
            [*values].map do |name|
              Nameserver.new(name.downcase)
            end
          end || []
        end


        # Initializes a new {Scanners::Verisign} instance
        # passing the {Whois::Answer::Parser::Base#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::Whoisbiz.new(content_for_scanner).parse
        end

      end

    end
  end
end
