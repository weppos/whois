#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.educause.edu server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisEducauseEdu < Base

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No Match/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Domain record activated:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Domain record last updated:\s+(.+?)\n/
            Time.parse($1) unless $1 == "unknown"
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Domain expires:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :registrant_contacts do
          if content_for_scanner =~ /Registrant:\n((.+\n)+)\n/
            lines = $1.split("\n").map(&:strip)

            case lines[-2]
              when /([^\n,]+),\s([A-Z]{2})(?:\s(\d{5}))/
                city, state, zip = $1, $2, $3
              else
                city = lines[-2]
            end

            Record::Contact.new(
              :type         => Whois::Record::Contact::TYPE_REGISTRANT,
              :name         => nil,
              :organization => lines[0],
              :address      => lines[1..-3].join("\n"),
              :city         => city,
              :state        => state,
              :zip          => zip,
              :country      => lines[-1]
            )
          end
        end

        property_supported :nameservers do
          if content_for_scanner =~ /Name Servers: \n((.+\n)+)\n/
            $1.split("\n").map do |line|
              name, ipv4 = line.strip.split(/\s+/)
              Record::Nameserver.new(name.downcase, ipv4)
            end
          end
        end

      end

    end
  end
end
