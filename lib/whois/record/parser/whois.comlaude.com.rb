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

      # Parser for the whois.comlaude.com server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      class WhoisComlaudeCom < Base

        property_not_supported :status

        # The server is contacted only in case of a registered domain.
        property_supported :available? do
          false
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Registered: (.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Expires: (.+)\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          Record::Registrar.new(
            :name => "NOM IQ LTD (DBA COM LAUDE)",
            :url  => "http://www.comlaude.com"
          )
        end

        property_supported :registrant_contacts do
          build_contact('Registrant Contact:', Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact('Admin Contact:', Record::Contact::TYPE_ADMINISTRATIVE)
        end

        property_supported :technical_contacts do
          build_contact('Technical Contact:', Record::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          if content_for_scanner =~ /Nameservers:\n((?:\s*[^\s\n]+\n)+)\n/
            $1.split("\n").map do |line|
              Record::Nameserver.new(:name => line.strip)
            end
          end
        end


      private

        def build_contact(element, type)
          match = content_for_scanner.slice(/#{element}\n((.+\n)*)\n\n/, 1)
          return unless match

          lines = match.split("\n").map(&:strip)

          # 0 Domain Manager
          # 1 Nom-IQ Ltd dba Com Laude
          #   2nd Floor, 28-30 Little Russell Street
          #   London WC1A 2HN
          #   United Kingdom
          #   Phone: +44.2078360070
          #   Fax: +44.2078360070
          #   Email: admin@comlaude.com
          Record::Contact.new(
            :type         => type,
            :name         => lines[0],
            :organization => lines[1],
            :address      => nil,
            :city         => nil,
            :state        => nil,
            :zip          => nil,
            :country      => nil,
            :phone        => match.slice(/Phone: (.*)/, 1),
            :email        => match.slice(/Email: (.*)/, 1),
            :fax          => match.slice(/Fax: (.*)/, 1),
          )
        end

      end

    end
  end
end
