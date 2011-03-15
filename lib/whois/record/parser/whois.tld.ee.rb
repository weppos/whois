#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/parser/scanners/base'


module Whois
  class Record
    class Parser

      #
      # = whois.tld.ee parser
      #
      # Parser for the whois.tld.ee server.
      #
      # NOTE: This parser is just a stub and provides only a few basic methods
      # to check for domain availability and get domain status.
      # Please consider to contribute implementing missing methods.
      # See WhoisNicIt parser for an explanation of all available methods
      # and examples.
      #
      class WhoisTldEe < Base
        include Features::Ast

        property_supported :status do
          if content_for_scanner =~ /status:\s+(.+)\n/
            case $1.downcase
              when "paid and in zone" then :registered
              # NEWSTATUS
              when "expired" then :expired
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
          if content_for_scanner =~ /registrar:\s+(.*)\n/
            Whois::Record::Registrar.new(
                :id => $1,
                :name => $1
            )
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
              Record::Nameserver.new($1, $2)
            else
              Record::Nameserver.new(line)
            end
          end
        end


        # Initializes a new {Scanner} instance
        # passing the {Whois::Record::Parser::Base#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanner.new(content_for_scanner).parse
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


          class Scanner < Scanners::Base

            def parse_content
              if @input.scan(/contact:\s+(.*)\n/)
                section = @input[1].strip
                content = {}

                while @input.scan(/(.*?):\s+(.*?)\n/)
                  content[@input[1]] = @input[2]
                end

                @ast[section] = content
              # FIXME: incomplete scanner, it skips all the properties
              else
                @input.scan(/(.*)\n/)
              end
            end

          end

      end
    end
  end
end
