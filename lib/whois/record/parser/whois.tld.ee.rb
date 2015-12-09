#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++

require 'whois/record/parser/base'
require 'whois/record/scanners/whois.tld.ee'

module Whois
  class Record
    class Parser

      # Parser for the whois.tld.ee server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisTldEe < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisTldEe


        property_supported :disclaimer do
          node('field:disclaimer').to_s.strip
        end


        property_supported :domain do
          if (content_for_scanner =~ /^Domain:\nname:\s+(.+)\n/)
            $1.to_s.strip.downcase
          end
        end

        property_not_supported :domain_id


        property_supported :status do
          if content_for_scanner =~ /status:\s+(.+?)\n/
            case $1
            when 'ok (paid and in zone)'
              :registered
            when 'expired'
              :expired
            else
              $1
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!node('status:available')
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /registered:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /changed:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /expire:\s+(.+?)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          node('Registrar') do |hash|
            Record::Registrar.new(
              name:         hash['name'],
              organization: hash['name'],
              url:          hash['url']
            )
          end
        end

        property_supported :registrant_contacts do
          build_contact('Registrant', Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('Administrative contact', Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact('Technical contact', Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          node('Name servers') do |hash|
            Array.wrap(hash['nserver']).map do |name|
              Nameserver.new(name: name.downcase)
            end
          end
        end


        private

        def build_contact(element, type)
          node(element) do |hash|
            el_size = Array.wrap(hash['name']).size

            (0...el_size).map do |i|
              Record::Contact.new(
                type:       type,
                name:       Array.wrap(hash['name'])[i],
                email:      Array.wrap(hash['email'])[i],
                updated_on: Time.parse(Array.wrap(hash['changed'])[i])
              )
            end
          end
        end

      end
    end
  end
end
