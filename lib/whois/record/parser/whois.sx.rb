#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.sx.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.sx server.
      # 
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @since  2.6.2
      class WhoisSx < Base
        include Scanners::Ast

        property_not_supported :disclaimer


        property_supported :domain do
          "#{node('Domain')}.sx"
        end

        property_not_supported :domain_id


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          case (s = node('Status'))
          when /free/
            :available
          when 'active'
            :registered
          else
            Whois.bug!(ParserError, "Unknown status `#{s}'.")
          end
        end

        property_supported :available? do
          status == :available
        end

        property_supported :registered? do
          !available?
        end


        property_not_supported :created_on

        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :registrar do
          node('Registrar') do |hash|
            Record::Registrar.new(
                :name         => hash['Name'],
                :url          => hash['Website']
            )
          end
        end


        property_supported :registrant_contacts do
          build_contact('Registrant', Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_not_supported :admin_contacts

        property_not_supported :technical_contacts


        property_supported :nameservers do
          node('Name servers') do |names|
            names.map do |name|
              Record::Nameserver.new(:name => name)
            end
          end
        end


        # Initializes a new {Scanners::WhoisSx} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisSx.new(content_for_scanner).parse
        end


        private

        def build_contact(element, type)
          node("#{element}") do |array|
            Record::Contact.new(
                :type         => type,
                :id           => nil,
                :name         => array[0],
                :email        => nil
            )
          end
        end

      end

    end
  end
end
