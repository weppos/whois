#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.nc.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.nc server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @since  2.4.0
      class WhoisNc < Base
        include Scanners::Nodable

        property_not_supported :disclaimer


        property_supported :domain do
          node("Domain")
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
          !!node("status:available")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Created on") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          node("Last updated on") { |value| Time.parse(value) }
        end

        property_supported :expires_on do
          node("Expires on") { |value| Time.parse(value) }
        end


        property_not_supported :registrar


        property_supported :registrant_contacts do
          node("Registrant name") do |str|
            address = []
            index   = 1
            while line = node("Registrant address #{index}")
              address << line
              index += 1
            end

            zip, city = address[-2].match(/(\d+) (.+)/)[1, 2]

            Record::Contact.new(
              :type         => Whois::Record::Contact::TYPE_REGISTRANT,
              :id           => nil,
              :name         => node("Registrant name"),
              :organization => nil,
              :address      => address[0..-3].join("\n"),
              :city         => city,
              :zip          => zip,
              :state        => nil,
              :country      => address[-1],
              :phone        => nil,
              :fax          => nil,
              :email        => nil
            )
          end
        end

        property_not_supported :admin_contacts

        property_not_supported :technical_contacts


        property_supported :nameservers do
          nameservers = []
          index   = 1
          while line = node("Domain server #{index}")
            nameservers << line
            index += 1
          end

          nameservers.map do |name|
            Record::Nameserver.new(:name => name)
          end
        end


        # Initializes a new {Scanners::WhoisNc} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisNc.new(content_for_scanner).parse
        end

      end

    end
  end
end
