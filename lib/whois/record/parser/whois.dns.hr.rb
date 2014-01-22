#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.dns.hr.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.dns.hr server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisDnsHr < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisDnsHr


        property_not_supported :disclaimer


        property_supported :domain do
          node("domain")
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


        property_not_supported :created_on

        property_not_supported :updated_on

        property_supported :expires_on do
          node("expires") { |value| Time.parse(value) }
        end


        property_not_supported :registrar


        property_supported :registrant_contacts do
          node("descr") do |array|
            _, zip, city = array[2].match(/([\d\s]+) (.+)/).to_a
            Record::Contact.new(
              :type         => Whois::Record::Contact::TYPE_REGISTRANT,
              :id           => nil,
              :name         => array[0],
              :organization => nil,
              :address      => array[1],
              :city         => city,
              :zip          => zip,
              :state        => nil,
              :country      => nil,
              :phone        => nil,
              :fax          => nil,
              :email        => nil
            )
          end
        end

        property_not_supported :admin_contacts

        property_not_supported :technical_contacts


        property_not_supported :nameservers

      end

    end
  end
end
