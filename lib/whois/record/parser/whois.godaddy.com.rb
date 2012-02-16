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

      # Parser for the whois.godaddy.com server.
      #
      # @note This parser is just a stub and provides only a few basic methods
      #   to check for domain availability and get domain status.
      #   Please consider to contribute implementing missing methods.
      # 
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @author Simone Carletti
      # @author Tom Nicholls <tom.nicholls@oii.ox.ac.uk>
      # @since  2.1.0
      class WhoisGodaddyCom < Base

        property_not_supported :status

        # The server is contacted only in case of a registered domain.
        property_supported :available? do
          false
        end

        property_supported :registered? do
          !available?
        end


        # property_supported :created_on do
        #   if content_for_scanner =~ /Created on: (.+)\n/
        #     Time.parse($1)
        #   end
        # end
        # 
        # property_supported :updated_on do
        #   if content_for_scanner =~ /Last Updated on: (.+)\n/
        #     Time.parse($1)
        #   end
        # end
        # 
        # property_supported :expires_on do
        #   if content_for_scanner =~ /Expires on: (.+)\n/
        #     Time.parse($1)
        #   end
        # end


        property_supported :registrar do
          Record::Registrar.new(
            :name => content_for_scanner[/Registered through: (.+)\n/, 1],
            :url => "http://www.godaddy.com/"
          )
        end

        property_supported :registrant_contacts do
          build_contact('Registrant:', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('Administrative Contact:', Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact('Technical Contact:', Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Domain servers in listed order:\n((.+\n)+)\n/
            $1.split("\n").map do |line|
              Record::Nameserver.new(line.strip)
            end
          end
        end


      private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}\n((.+\n)+)\n/, 1)
          return unless match

          lines = $1.split("\n").map(&:strip)

          # Lines 1 and 5 may be absent, depending on the record.
          # The parser attempts to correct for this, but may be a bit flaky
          # on non-standard data.
          #
          # 0 GoDaddy.com, Inc., GoDaddy.com, Inc.  dns@jomax.net
          # 1 GoDaddy.com, Inc.
          # 2 14455 N Hayden Rd Suite 219
          # 3 Scottsdale, Arizona 85260
          # 4 United States
          # 5 +1.4805058800      Fax -- +1.4805058844
          phone = nil
          fax   = nil
          if lines[-1].to_s =~ /Fax --/
             phone, fax = lines.delete_at(-1).to_s.scan(/^(.*) Fax --(.*)$/).first
             phone = phone.strip
             fax   = fax.strip
          end

          Record::Contact.new(
            :type         => type,
            :id           => nil,
            :name         => lines[0].to_s.gsub(/\s\S+@[^\.].*\.[a-z]{2,}\s?\)?$/, "").strip,
            :organization => lines.length >= 5 ? lines[-4] : "",
            :address      => lines.length >= 4 ? lines[-3] : "",
            :city         => lines.length >= 4 ? lines[-2].to_s.partition(",")[0] : "",
            :zip          => lines.length >= 4 ? lines[-2].to_s.rpartition(" ")[2] : "",
            :state        => lines.length >= 4 ? lines[-2].to_s.partition(",")[2].rpartition(" ")[0].to_s.strip : "",
            :country      => lines.length >= 4 ? lines[-1] : "",
            :phone        => phone,
            :fax          => fax,
            :email        => lines[0].to_s.scan(/[^\s]\S+@[^\.].*\.[a-z]{2,}[^\s\)\n]/).first
          )
        end

      end

    end
  end
end
