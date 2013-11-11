#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.ascio.com'


module Whois
  class Record
    class Parser

      # Parser for the whois.ascio.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisAscioCom < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisAscioCom


        property_supported :disclaimer do
          node("field:disclaimer")
        end


        property_supported :domain do
          if content_for_scanner =~ /Domain name: (.+)\n/
            $1.downcase
          end
        end

        property_not_supported :domain_id


        property_supported :available? do
          !!(content_for_scanner =~ /^Object not found/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Record created: (.+)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Record last updated: (.+)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Record expires: (.+)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          return unless registered?
          Record::Registrar.new(
              id:           "ASCIOTEC1364",
              name:         "Ascio Technologies",
              organization: "Ascio Technologies, Inc",
              url:          "http://www.ascio.com/"
          )
        end


        property_supported :registrant_contacts do
          build_contact('Registrant:', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          if content_for_scanner =~ /Administrative and Technical contact:/
            build_contact('Administrative and Technical contact:', Record::Contact::TYPE_ADMINISTRATIVE)
          else
            build_contact('Administrative contact:', Record::Contact::TYPE_ADMINISTRATIVE)
          end
        end

        property_supported :technical_contacts do
          if content_for_scanner =~ /Administrative and Technical contact:/
            build_contact('Administrative and Technical contact:', Record::Contact::TYPE_TECHNICAL)
          else
            build_contact('Technical contact:', Record::Contact::TYPE_TECHNICAL)
          end
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Domain servers in listed order:\n((?:[^\n]+\n)+)/
            $1.split("\n").map do |line|
              # ns1.ascio.net (NSASCION521)
              name  = line.strip.split(" ").first
              Record::Nameserver.new(name: name.downcase)
            end
          end
        end


        private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}.*\n((.*\n){8})/, 1)
          return unless match

          lines = match.split("\n").map(&:strip)

          # Registrant:
          # 0 ASCIO Technologies Inc. (ASCIOTEC1364)    | Dacentec BVBA (DACENTEC94997)
          # 1 Islands Brygge 55                         | Antwerpsesteenweg 19
          # 2                                           |
          # 3 Copenhagen, S, 2300                       | Lochristi, , 9080
          # 4 DK                                        | BE

          # Administrative and Technical contact:
          # 0 Hostmaster, Netnames (NH323743)           | Fossen, Arvid (AF05750)
          # 1 Group NBT                                 | Dacentec BVBA
          # 2 3rd Floor Prospero House                  | Antwerpsesteenweg 19
          # 3 241 Borough High St.                      |
          # 4 London, SE1 1GA                           | Lochristi, 9080
          # 5 GB                                        | BE
          # 6 hostmaster@netnames.net                   | arvid@dacentec.com
          # 7 +44.2070159370 Fax: +44.2070159375        | +32.093242050 Fax:

          phone, fax, email = nil

          # (id) check on the end of the line
          if lines[0].to_s =~ /(.+) \((.+)\)/
            name, id = lines.shift.to_s.scan(/(.+) \((.+)\)/).first.map(&:strip)
          else
            name, id = lines.shift.strip, nil
          end

          if type == Record::Contact::TYPE_REGISTRANT
            organization, name = name, nil
          else

            # name reverse in right order without comma
            name = name.split(',').map(&:strip).reverse.join(' ') if name
            organization = lines.shift

            # Does the last line contains the word fax, or has >9 digits
            if lines[-1].to_s =~ / [Ff]ax: [\d\+\.]+/
              phone, fax  = lines.pop.to_s.scan(/^(.+) [Ff]ax: (.+)$/).first.map(&:strip)
            elsif lines[-1].to_s.gsub!(/ [Ff]ax:/, '').gsub(/[^\d]+/, '').length > 9
              phone = lines.pop
            end

            email = lines.pop
          end

          address = lines[0..1].join(' ').strip
          if lines[2].to_s =~ /^(.+), (.*), (.+)$/
            city, state, zip = lines[2].scan(/^(.+), (.*), (.+)$/).first.map(&:strip)
            state = nil if state.empty?
          else
            state = nil
            city, zip = lines[2].scan(/^(.+), (.+)$/).first.map(&:strip)
          end
          country_code = lines[3]
          Record::Contact.new(
              type:         type,
              id:           id,
              name:         name,
              organization: organization,
              address:      address,
              city:         city,
              state:        state,
              zip:          zip,
              country_code: country_code,
              email:        email,
              phone:        phone,
              fax:          fax
          )
        end

      end

    end
  end
end
