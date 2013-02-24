#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.nic.hu.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.hu server.
      #
      # @author Simone Carletti <weppos@weppos.net>
      # @author Gábor Vészi <veszig@done.hu>
      #
      class WhoisNicHu < Base
        include Scanners::Nodable

        property_supported :disclaimer do
          node("field:disclaimer")
        end


        property_supported :domain do
          node("field:domain")
        end

        property_supported :domain_id do
          node("hun-id")
        end


        property_supported :status do
          if node("status:available")
            :available
          elsif node("status:inprogress")
            :registered
          else
            :registered
          end
        end

        property_supported :available? do
          status == :available
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("registered") { |raw| Time.parse(raw) }
        end

        property_supported :updated_on do
          node("changed") { |raw| Time.parse(raw) }
        end

        property_not_supported :expires_on


        property_supported :registrar do
          if c = registrar_contact
            Record::Registrar.new(
              :id => c[:id],
              :name => c[:name],
              :organization => c[:organization]
            )
          end
        end

        property_supported :registrant_contacts do
          return unless node("name")

          address, city, zip, country_code = decompose_address(node("address"))

          Record::Contact.new(
              :type         => Whois::Record::Contact::TYPE_REGISTRANT,
              :name         => node("name"),
              :organization => node("org"),
              :address      => address,
              :city         => city,
              :zip          => zip,
              :country_code => country_code,
              :phone        => node("phone"),
              :fax          => node("fax-no")
          )
        end

        property_supported :admin_contacts do
          build_contact("admin-c", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact("tech-c", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          Array.wrap(node("nameserver")).map do |name|
            Record::Nameserver.new(:name => name)
          end
        end


        # NEWPROPERTY
        def registrar_contact
          cached_properties_fetch(:registrar_contact) do
            build_contact("registrar", nil)
          end
        end

        # NEWPROPERTY
        def zone_contact
          cached_properties_fetch(:zone_contact) do
            build_contact("zone-c", nil)
          end
        end


        # Initializes a new {Scanners::WhoisNicHu} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisNicHu.new(content_for_scanner).parse
        end


      private

        def build_contact(element, type)
          node(node(element)) do |raw|
            Record::Contact.new do |c|
              c.type = type
              raw.each { |k,v| c[k.to_sym] = v }
            end
          end
        end

        # Depending on record type, the address can be <tt>nil</tt>
        # or an array containing different address parts.
        def decompose_address(parts)
          addresses = parts || []
          address, city, zip, country_code = nil, nil, nil, nil

          if !addresses.empty?
            address       = addresses[0]                if addresses[0]
            zip, city     = addresses[1].split(" ", 2)  if addresses[1]
            country_code  = addresses[2]                if addresses[2]
          end

          [address, city, zip, country_code]
        end

      end

    end
  end
end
