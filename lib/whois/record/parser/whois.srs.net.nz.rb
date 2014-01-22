#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.srs.net.nz.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.srs.net.nz server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisSrsNetNz < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisSrsNetNz


        property_supported :domain do
          node("domain_name")
        end

        property_not_supported :domain_id


        # @see http://dnc.org.nz/content/srs-whois-spec-1.0.html
        property_supported :status do
          node("query_status") do |value|
            case value.downcase
            when "200 active"
              :registered
            # The domain is no longer active but is in the period prior
            # to being released for general registrations
            when "210 pendingrelease"
              :redemption
            when "220 available"
              :available
            when "404 request denied"
              :error
            when /invalid characters/
              :invalid
            else
              Whois.bug!(ParserError, "Unknown status `#{value}'.")
            end
          end || Whois.bug!(ParserError, "Unable to parse status.")
        end

        property_supported :available? do
          status == :available
        end

        property_supported :registered? do
          status == :registered || status == :redemption
        end


        property_supported :created_on do
          node("domain_dateregistered") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          node("domain_datelastmodified") { |value| Time.parse(value) }
        end

        property_supported :expires_on do
          node("domain_datebilleduntil") { |value| Time.parse(value) }
        end


        property_supported :registrar do
          node("registrar_name") do |value|
            Record::Registrar.new(
              name:         value
            )
          end
        end

        property_supported :registrant_contacts do
          build_contact("registrant", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact("admin", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact("technical", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          (1..4).map do |i|
            node("ns_name_0#{i}") { |value| Record::Nameserver.new(name: value) }
          end.compact
        end


        # Checks whether the response has been throttled.
        #
        # @return [Boolean]
        #
        # @example
        #   query_status: 440 Request Denied
        #
        def response_throttled?
          cached_properties_fetch(:response_throttled?) do
            node("query_status") == "440 Request Denied"
          end
        end


        # NEWPROPERTY
        def valid?
          cached_properties_fetch(:valid?) do
            !invalid?
          end
        end

        # NEWPROPERTY
        def invalid?
          cached_properties_fetch(:invalid?) do
            status == :invalid
          end
        end

      
      private

        def build_contact(element, type)
          node("#{element}_contact_name") do
            Record::Contact.new(
              type:         type,
              id:           nil,
              name:         node("#{element}_contact_name"),
              address:      node("#{element}_contact_address1"),
              city:         node("#{element}_contact_city"),
              zip:          node("#{element}_contact_postalcode"),
              state:        node("#{element}_contact_province"),
              country:      node("#{element}_contact_country"),
              phone:        node("#{element}_contact_phone"),
              fax:          node("#{element}_contact_fax"),
              email:        node("#{element}_contact_email")
            )
          end
        end

      end

    end
  end
end
