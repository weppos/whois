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
      # = whois.educause.edu parser
      #
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
          # TODO use named captures in Ruby 1.9
          if content_for_scanner =~ /Registrant:\s+(.+?)\n(\s+(.+?)\n)?\s+([^\n,]+),\s([A-Z]{2})(?:\s(\d{5}))\n\s+UNITED STATES/m
            school  = $1  # e.g. Carnegie Mellon University
            address = $2  # e.g. "Cyert Hall 215\n5000 Forbes Avenue"
            # $3 is city wrapped in whitespace
            city    = $4  # e.g. Pittsburgh
            state   = $5  # e.g. PA
            zip     = $6  # e.g. 15213
            
            Record::Contact.new(
              :type         => Whois::Record::Contact::TYPE_REGISTRANT,
              :name         => school,
              :organization => school,
              :address      => (address.strip if address),
              :city         => city,
              :state        => state,
              :zip          => zip,
              :country      => 'UNITED STATES', # all .EDU records
              :country_code => 'US'             # ''
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
