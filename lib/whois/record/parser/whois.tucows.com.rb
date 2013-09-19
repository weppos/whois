#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.centralnic.com'


module Whois
  class Record
    class Parser

      # Parser for the whois.tucows.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @author Simone Carletti
      # @author Igor Dolzhikov <bluesriverz@gmail.com>
      # @since  3.2.1
      #
      class WhoisTucowsCom < Base

        property_supported :domain do
          if content_for_scanner =~ /Domain name:\s(.+)\n/
            $1.strip.downcase
          end
        end

        property_not_supported :domain_id

        property_supported :status do
          if content_for_scanner =~ /Domain status:\s((.+\n)*)\n/
            $1.split("\n").map(&:strip)
          end
        end

        # The server is contacted only in case of a registered domain.
        property_supported :available? do
          false
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Record created on (.+)\.\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Record last updated on (.+)\.\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Record expires on (.+)\.\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          Record::Registrar.new(
              :name => "TUCOWS",
              :organization => "TUCOWS, INC.",
              :url  => "http://tucowsdomains.com/"
          )
        end

        property_supported :registrant_contacts do
          build_contact('Registrant:', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('Administrative Contact:', Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact('Technical Contact:', Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Domain servers in listed order:\n((?:[^\n]+\n)+)/
            $1.split("\n").map do |line|
              # NS3.TUCOWS.COM   64.99.97.32
              name, ipv4 = line.strip.split(" ")
              Record::Nameserver.new(:name => name.downcase, :ipv4 => ipv4)
            end
          end
        end


        private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}.*\n((.+\n){4,6})(.*\sTech|\n)/, 1)
          return unless match

          lines = match.split("\n").map(&:strip)

          # 0 Tucows.com Co
          # 1 96 Mowat Avenue
          # 2 Toronto, Ontario M6K3M1
          # 3 CA

          # 0 Cuesta, Raul  rcuesta@rehje.com
          # 1 Moliere 450A-101
          # 2 Mexico D.F., NA 11560
          # 3 MX
          # 4 011525552506552

          # 0 Bowyer, John  john@jabbdesign.com
          # 1 8D
          # 2 Craven Rd
          # 3 Newbury, Berkshire RG14 5NE
          # 4 GB
          # 5 +44.07967570273    Fax: +44.7967570273

          # Does the last line contains the word fax, or has >9 digits
          phone, fax = nil
          if lines[-1].to_s =~ / [Ff]ax: /
            phone, fax  = lines.pop.to_s.scan(/^(.+) [Ff]ax: (.+)$/).first
            phone = phone.strip
            fax   = fax.strip
          elsif lines[-1].to_s.gsub(/[^\d]+/, '').length > 9
            phone = lines.pop
          end

          # Does the first line end in something that looks like a email address?
          name, email, organization = nil
          if lines[0].to_s =~ /\S+@\S+$/
            name, email = lines[0].scan(/^(.+)\s(\S+@\S+)$/).first
            name = name.split(',').map(&:strip).reverse.join(' ') if name
          else
            organization = lines[0]
          end

          address = lines[1..-3].join(' ')
          city, state, zip = lines[-2].scan(/^(.+), (\w+) (.+)$/).first
          Record::Contact.new(
              :type         => type,
              :name         => name,
              :organization => organization,
              :address      => address,
              :city         => city,
              :state        => state,
              :zip          => zip,
              :country_code => lines[-1],
              :email        => email,
              :phone        => phone,
              :fax          => fax
          )
        end

      end

    end
  end
end
