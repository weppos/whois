#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2015 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.ja.net server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisJaNet < Base

        property_supported :domain do
          if content_for_scanner =~ /^Domain:\n\s+(.+?)\n/
            $1.strip.downcase
          end
        end

        # @see https://community.jisc.ac.uk/library/janet-services-documentation/list-registrars Jisc approved registrars
        property_supported :registrar do
          Record::Registrar.new(
            :id           => nil,
            :name         => content_for_scanner[/Registered By:\n\s*(.+)\n/, 1],
            :organization => content_for_scanner[/Registered By:\n\s*(.+)\n/, 1],
            :url          => nil
          )
        end

        # @note Address formatting is not reliable enough for simple parsing.
        #   Treating "Domain Owner" as the registrant organisation
        property_supported :registrant_contacts do
          address = phone = fax = email = nil
          textblock = content.slice(/Registrant Address:\n((.+\n)+)\n/, 1).gsub(/\t/,'')
          phone = textblock.slice(/\s+(\+.+) \(Phone\)/, 1)
          fax   = textblock.slice(/\s+(\+.+) \(FAX\)\n/, 1)
          email = textblock.slice(/\s+(.*@.*)\n/, 1)
          address = textblock.gsub(/(.*@.*|.* \((Phone|FAX)\)\n)/,'').strip
          Record::Contact.new(
              :type => Record::Contact::TYPE_REGISTRANT,
              :organization => content_for_scanner[/Domain Owner:\n\s*(.+)\n/, 1],
              :name => content_for_scanner[/Registrant Contact:\n\s*(.+)\n/, 1],
              :address => address,
              :city => nil,
              :state => nil,
              :zip => nil,
              :country => nil,
              :phone => phone,
              :fax => fax,
              :email => email
          )
        end

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^No such domain (.+)/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /^Entry created:\n\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /^Entry updated:\n\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /^Renewal date:\n\s+(.+?)\n/
            Time.parse($1)
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Servers:\n((.+\n)+)\n/
            $1.split("\n").map do |line|
              name, ips = line.strip.downcase.split("\t")
              ipv4 = [ips].find { |ip| Whois::Server.valid_ipv4?(ip) }
              ipv6 = [ips].find { |ip| Whois::Server.valid_ipv6?(ip) }
              Record::Nameserver.new(:name => name, :ipv4 => ipv4, :ipv6 => ipv6)
            end
          end
        end

        property_not_supported :disclaimer

        property_not_supported :admin_contacts

        property_not_supported :technical_contacts

      end

    end
  end
end
