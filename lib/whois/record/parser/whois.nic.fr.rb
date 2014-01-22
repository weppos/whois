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

      # Parser for the whois.nic.fr server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicFr < Base

        property_supported :status do
          if content_for_scanner =~ /status:\s+(.+)\n/
            case $1.downcase
            when "active"     then :registered
            when "registered" then :registered
            when "redemption" then :redemption
            when "blocked"    then :inactive
            # The 'frozen' status seems to be a status
            # where a registered domain is placed to prevent changes
            # and/or when changes can't be made.
            when "frozen"     then :registered
            # The 'not_open' status seems to indicate a domain
            # that is already reserved and can't be registered directly.
            # This is the case of second level names.
            when "not_open"   then :reserved
            else
              Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No entries found in the AFNIC Database/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /created:\s+(.+)\n/
            d, m, y = $1.split("/")
            Time.parse("#{y}-#{m}-#{d}")
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /last-update:\s+(.+)\n/
            d, m, y = $1.split("/")
            Time.parse("#{y}-#{m}-#{d}")
          end
        end

        # TODO: Use anniversary
        property_not_supported :expires_on


        property_supported :registrant_contacts do
          parse_contact("holder-c", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          parse_contact("admin-c", Whois::Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          parse_contact("tech-c", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |line|
            if line =~ /(.+) \[(.+)\]/
              name = $1
              ips  = $2.split(/\s+/)
              ipv4 = ips.find { |ip| Whois::Server.valid_ipv4?(ip) }
              ipv6 = ips.find { |ip| Whois::Server.valid_ipv6?(ip) }
              Record::Nameserver.new(:name => name, :ipv4 => ipv4, :ipv6 => ipv6)
            else
              Record::Nameserver.new(:name => line)
            end
          end
        end

        # Checks whether the response has been throttled.
        #
        # @return [Boolean]
        def response_throttled?
          !!(content_for_scanner =~ /^%% Too many requests\.{3}/)
        end


      private

        MULTIVALUE_KEYS = %w( address )

        def parse_contact(element, type)
          return unless content_for_scanner =~ /#{element}:\s+(.+)\n/

          id = $1
          content_for_scanner.scan(/nic-hdl:\s+#{id}\n((.+\n)+)\n/).any? ||
              Whois.bug!(ParserError, "Unable to parse contact block for nic-hdl: #{id}")
          values = build_hash($1.scan(/(.+?):\s+(.+?)\n/))

          if values["type"] == "ORGANIZATION"
            name = nil
            organization = values["contact"]
            address = values["address"].join("\n")
          else
            name = values["contact"]
            if values["address"].nil?
              organization = nil
              address      = nil
            elsif values["address"].size > 2
              organization = values["address"][0]
              address      = values["address"][1..-1].join("\n")
            else
              organization = nil
              address      = values["address"].join("\n")
            end
          end

          updated_on = values["changed"] ? Time.utc(*values["changed"].split(" ").first.split("/").reverse) : nil

          Record::Contact.new({
            :type         => type,
            :id           => id,
            :name         => name,
            :organization => organization,
            :address      => address,
            :country_code => values["country"],
            :phone        => values["phone"],
            :fax          => values["fax-no"],
            :email        => values["e-mail"],
            :updated_on   => updated_on,
          })
        end

        def build_hash(tokens)
          {}.tap do |hash|
            tokens.each do |key, value|
              if MULTIVALUE_KEYS.include?(key)
                hash[key] ||= []
                hash[key] <<  value
              else
                hash[key] = value
              end
            end
          end
        end


      end

    end
  end
end
