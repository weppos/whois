#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      #
      # = whois.nic.fr parser
      #
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
              # NEWSTATUS (reserved)
              when "frozen"     then :frozen
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


        property_supported :admin_contacts do
          parse_contact("admin-c", Whois::Record::Contact::TYPE_ADMIN)
        end


        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |line|
            if line =~ /(.+) \[(.+)\]/
              Record::Nameserver.new($1, *$2.split(/\s+/))
            else
              Record::Nameserver.new(line)
            end
          end
        end


        private

        MULTIVALUE_KEYS = %w( address )

        def parse_contact(element, type)
          return unless content_for_scanner =~ /#{element}:\s+(.+)\n/

          id = $1
          content_for_scanner.scan(/nic-hdl:\s+#{id}\n((.+\n)+)\n/).any? ||
              Whois.bug!(ParserError, "Unable to parse contact block for nic-hdl: #{id}")
          p values = build_hash($1.scan(/(.+?):\s+(.+?)\n/))

          if values["type"] == "ORGANIZATION"
            name = nil
            organization = values["contact"]
            address = address[0..-1].join("\n")
            zip, city = values["address"][-1].split(" ")
          else
            name = values["contact"]
            if values["address"] > 2
              organization = values["address"][0]
              address = address[1..-1].join("\n")
            else
              organization = nil
              address = address[0..-1].join("\n")
            end
            zip, city = values["address"].last.split(" ")
          end

          Record::Contact.new({
            :type         => type,
            :id           => id,
            :name         => name,
            :organization => organization,
            :address      => address,
            :city         => city,
            :zip          => zip,
            # :state        => "",
            # :country      => "",
            :country_code => values["country"],
            :phone        => values["phone"],
            :fax          => values["fax-no"],
            :email        => values["e-mail"],
            # :created_on   => "",
            :updated_on   => Time.new(*values["changed"].split(" ").first.split("/").reverse),
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
