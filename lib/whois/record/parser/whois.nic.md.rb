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

      #
      # = whois.nic.md parser
      #
      # Parser for the whois.nic.md server.
      #
      class WhoisNicMd < Base

        property_not_supported :disclaimer


        property_supported :domain do
          if content_for_scanner =~ /Domain name:\s(.+?)\n/
            $1
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
          !!(content_for_scanner.strip == "No match for")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created:\s(.+?)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Expiration date:\s+(.+?)\n/
            Time.parse($1)
          end
        end


        property_not_supported :registrar


        property_supported :registrant_contacts do
          if content_for_scanner =~ /Registrant:\s+(.+?)\n/
            Record::Contact.new(
                :type => Whois::Record::Contact::TYPE_REGISTRANT,
                :name => $1
            )
          end
        end

        property_not_supported :admin_contacts

        property_not_supported :technical_contacts


        property_supported :nameservers do
          content_for_scanner.scan(/Name server:\s(.+?)\n/).flatten.map do |line|
            name, ipv4 = line.split(/\s+/)
            Record::Nameserver.new(:name => name, :ipv4 => ipv4)
          end
        end

      end

    end
  end
end
