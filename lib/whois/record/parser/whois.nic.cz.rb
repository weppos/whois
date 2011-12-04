#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/parser/scanners/whois.nic.cz.rb'

module Whois
  class Record
    class Parser

      #
      # = whois.nic.cz parser
      #
      # Parser for the whois.nic.cz server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisNicCz < Base
        include Scanners::Ast

        property_supported :domain do
          if registered? and content_for_scanner =~ /domain:\s+(.+)\n/
            $1
          end
        end

        property_not_supported :domain_id

        property_supported :status do
          if content_for_scanner =~ /status:\s+(.+)\n/
            case $1.downcase
              when "paid and in zone", "update prohibited"
                :registered
              # NEWSTATUS
              when "expired"
                :expired
              else
                Whois.bug!(ParserError, "Unknown status `#{$1}'.")
            end
          else
            :available
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /^%ERROR:101: no entries found/)
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /registered:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /changed:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /expire:\s+(.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :registrar do
          if content_for_scanner =~ /registrar:\s+(.+)\n/
            Whois::Record::Registrar.new(:id => $1, :name => $1)
          end
        end

        property_supported :admin_contacts do
          if content_for_scanner =~ /admin-c:\s+(.*)\n/
            contact($1, Whois::Record::Contact::TYPE_ADMIN)
          end
        end

        property_supported :registrant_contacts do
          if content_for_scanner =~ /registrant:\s+(.*)\n/
            contact($1, Whois::Record::Contact::TYPE_REGISTRANT)
          end
        end

        property_not_supported :technical_contacts

        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |line|
            if line =~ /(.+) \((.+)\)/
              Record::Nameserver.new($1, *$2.split(", "))
            else
              Record::Nameserver.new(line.strip)
            end
          end
        end

        # Initializes a new {Scanners::WhoisTldEe} instance
        # passing the {#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanners::WhoisNicCz.new(content_for_scanner).parse
        end

        protected

          def contact(element, type)
            node(element) do |raw|
              Record::Contact.new(
                :id             => element,
                :type           => type,
                :name           => raw['name'],
                :organization   => raw['org'],
                :created_on     => Time.parse(raw['created'])
              )
            end
          end

      end

    end
  end
end
