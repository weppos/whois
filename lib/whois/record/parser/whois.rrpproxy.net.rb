#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
# Copyright (c) 2012 SophosLabs http://www.sophos.com
#++
require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.rrpproxy.net server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @since 2.4.0
      class WhoisRrpproxyNet < Base

        property_not_supported :status

        # The server is contacted only in case of a registered domain.
        property_supported :available? do
          false
        end

        property_supported :registered? do
          !available?
        end

        property_not_supported :created_on
        property_not_supported :updated_on

        property_not_supported :expires_on


        property_supported :registrar do
          Record::Registrar.new(
            :name => "KEY-SYSTEMS GMBH",
            :organization => "KEY-SYSTEMS GMBH",
            :url  => "http://www.key-systems.net"
          )
        end

        property_supported :registrant_contacts do
          build_contact('owner-contact:', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('admin-contact:', Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact('tech-contact:', Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :nameservers do
          if content_for_scanner =~ /((nameserver:\s*(.+)\n)+)\n/
            $1.split("\n").map do |line|
              Record::Nameserver.new(line.gsub(/nameserver:/, '').strip.split(/\s+/)[0])
            end
          end
        end

      private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}((.+\n)+)\n/)
          return unless match

          lines = match.split("\n").map(&:strip)
          #owner-contact: Contact
          #owner-organization: Organization
          #owner-fname: Firstname   ...or #owner-title: Title
          #owner-mname: Middlename  ...or #owner-fname: Fistname
          #owner-lname: Lastname    ...or #owner-lname: Lastname
          #owner-street: Address
          #owner-city: City
          #owner-state: State
          #owner-zip: Zip
          #owner-country: Countrycode
          #owner-phone: phone
          #owner-fax: fax -- optional
          #owner-email: email

          pattern = /^.+:\s*/
          contents = lines[1..-1]
          return if contents.nil? or contents.length < 12
          title = nil
          if contents[1] =~ /title/
              title = contents[1].gsub(pattern, '').strip
          end
          organization, fname, mname, lname, street, city, state, zip, country, phone, fax, email  = \
            contents.map { |c| c.gsub(pattern, '').strip };
          
          fname = mname unless title.nil?
          
          email, fax = [fax, nil] unless email

          Record::Contact.new(
            :type         => type,
            :name         => "#{fname} #{lname}",
            :organization => organization,
            :address      => street,
            :city         => city,
            :state        => state,
            :country_code => country,
            :zip          => zip,
            :email        => email,
            :phone        => phone,
            :fax          => fax
          )
        end

      end

    end
  end
end
