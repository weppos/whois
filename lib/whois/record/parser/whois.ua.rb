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

      # Parser for the whois.ua server.
      #
      # @since  2.4.0
      class WhoisUa < Base

        property_supported :domain do
          if content_for_scanner =~ /domain:\s+(.+)\n/
            $1
          end
        end

        property_not_supported :domain_id

  
        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          if content_for_scanner =~ /status:\s+(.+?)\n/
            case (s = $1.downcase)
            when /^ok-until/
              :registered
            else
              Whois.bug!(ParserError, "Unknown status `#{s}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /No entries found for domain/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /created:\s+(.+)\n/
            time = $1.split(" ").last
            Time.parse(time) unless time =~ /\A[0]+\z/
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /changed:\s+(.+)\n/
            time = $1.split(" ").last
            Time.parse(time)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /status:\s+(.+)\n/
            time = $1.split(" ").last
            Time.parse(time)
          end
        end


        property_not_supported :registrar

        property_not_supported :registrant_contacts

        property_supported :admin_contacts do
          build_contact("Administrative", Whois::Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact("Technical", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |name|
            Record::Nameserver.new(:name => name.strip.downcase)
          end
        end


      private

        def build_contact(element, type)
          record = []
          content_for_scanner.scan(/%\s#{element}\sContact:\n %\s=+\n ((?: .+\n)+) (?: \n|\z)/ix).flatten.each do |match|
            address = match.scan(/address:\s+(.+)\n/).flatten
            zip = nil
            zip = address[1].slice!(/\s+\d{5}/).strip if address[1] =~ /\s+\d{5}/
            zip = address[1].slice!(/\d{5}\s+/).strip if address[1] =~ /\d{5}\s+/
            state = nil
            state = address[1].slice!(/\s+[A-Z]{2}\z/).strip if address[1] =~ /\s+[A-Z]{2}\z/
            
            record.push Record::Contact.new(
              :type         => type,
              :id           => match[/org-id:\s+(.+)\n/,1],
              :name         => nil,
              :organization => match.scan(/organization:\s+(.+)\n/).join("\n"),
              :address      => address[0],
              :zip          => zip,
              :state        => state,
              :city         => address[1],
              :country      => address[2],
              :phone        => match[/phone:\s+(.+)\n/,1],
              :fax          => match[/fax-no:\s+(.+)\n/,1],
              :email        => match[/e-mail:\s+(.+)\n/,1],
              :updated_on   => (Time.parse($1.split(" ").last) if match =~ /changed:\s+(.+)\n/)
            )
          end
          record
        end

      end

    end
  end
end
