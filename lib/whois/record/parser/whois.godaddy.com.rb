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
      # = whois.godaddy.com parser
      #
      # Parser for the whois.godaddy.com server.
      # Contributed by Tom Nicholls <tom.nicholls@oii.ox.ac.uk>
      #
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #

      class WhoisGodaddyCom < Base

        property_not_supported :status

        # The server seems to provide only information for registered domains
        property_supported :available? do
          false
        end

        property_supported :registered? do
          !available?
        end

        property_supported :created_on do
          if content_for_scanner =~ /Created on: (.+)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Last Updated on: (.+)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expires on: (.+)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          Record::Registrar.new(
            :name => content_for_scanner[/Registered through: (.+) \(/, 1],
            :url  => content_for_scanner[/Registered through: .*\((.+)\)\n/, 1]
          )
        end


        property_supported :registrant_contacts do
          contact('Registrant:', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          contact('Administrative Contact:', Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          contact('Technical Contact:', Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :nameservers do
          content_for_scanner[/Domain servers in listed order:\n((?:\s*[^\s\n]+\n)+)\n\s*\n/, 1].split("\n").map do |line|
            Record::Nameserver.new(line.strip)
          end
        end


        private


          def contact(element, type)
            info = content_for_scanner[/#{element}\n((.+\n)+)\n/, 1].to_s.split("\n").map(&:strip)
            # NB: Lines 1 and 5 may be absent, depending on the record.
            # The parser attempts to correct for this, but may be a bit flaky
            # on non-standard data.
            # 0 GoDaddy.com, Inc., GoDaddy.com, Inc.  dns@jomax.net
            # 1 GoDaddy.com, Inc.
            # 2 14455 N Hayden Rd Suite 219
            # 3 Scottsdale, Arizona 85260
            # 4 United States
            # 5 +1.4805058800      Fax -- +1.4805058844
            phone = ""
	    fax = ""
            if info[-1].to_s =~ /Fax --/
               phone, fax = info.delete_at(-1).to_s.scan(/^(.*) Fax --(.*)$/).first
               phone = phone.strip
               fax = fax.strip
            end
            Record::Contact.new(
              :type => type,
              :name => info[0].to_s.gsub(/\s\S+@[^\.].*\.[a-z]{2,}\s?\)?$/, "").strip,
              :organization => info.length >= 5 ? info[-4] : "",
              :address => info.length >= 4 ? info[-3] : "",
              :city => info.length >= 4 ? info[-2].to_s.partition(",")[0] : "",
              :state => info.length >= 4 ? info[-2].to_s.partition(",")[2].rpartition(" ")[0].to_s.strip : "",
              :zip => info.length >= 4 ? info[-2].to_s.rpartition(" ")[2] : "",
              :country_code => info.length >= 4 ? info[-1] : "",
              :email => info[0].to_s.scan(/[^\s]\S+@[^\.].*\.[a-z]{2,}[^\s\)\n]/).first,
              :phone => phone,
              :fax => fax
            )
          end

      end

    end
  end
end
