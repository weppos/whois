#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.es server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisNicEs < Base

        property_supported :domain do
          if content_for_scanner =~ /Domain Name:\s+(.+)\n/
            $1.downcase
          end
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
          !!(content_for_scanner =~ /There is no information available on the domain consulted/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Creation Date:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Expiration Date:\s+(.+)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          Record::Registrar.new(
              :name         => 'ES-NIC',
              :organization => 'ES-NIC Delegated Internet Registry for Spain',
          )
        end


        property_supported :registrant_contacts do
          if content_for_scanner =~ /Registrant Name:\s+(.+)\n/
            Record::Contact.new(
                type:         Whois::Record::Contact::TYPE_REGISTRANT,
                id:           nil,
                name:         $1.to_s.strip,
                organization: nil,
                address:      nil,
                city:         nil,
                zip:          nil,
                state:        nil,
                country:      nil,
                phone:        nil,
                fax:          nil,
                email:        nil
            )
          end
        end

        property_not_supported :admin_contacts

        property_not_supported :technical_contacts


        property_supported :nameservers do
          content_for_scanner.scan(/Name Server \d{1}:\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(name: name)
          end
        end

      end

    end
  end
end
