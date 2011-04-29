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
      # = whois.denic.de parser
      #
      # Parser for the whois.denic.de server.
      #
      # @author Simone Carletti <weppos@weppos.net>
      # @author Aaron Mueller <mail@aaron-mueller.de>
      #
      class WhoisDenicDe < Base
        include Features::Ast

        property_supported :disclaimer do
          node("Disclaimer")
        end


        property_supported :domain do
          node("Domain")
        end

        property_not_supported :domain_id


        property_supported :status do
          if node("Status")
            case node("Status")
              when "connect"    then :registered
              when "free"       then :available
              when "invalid"    then :invalid
              # NEWSTATUS
              # The domain is registered, but there is not DNS entry for it.
              when "failed"     then :registered
              else
                Whois.bug!(ParserError, "Unknown status `#{node("Status")}'.")
            end
          else
            if version < "2.0"
              if invalid?
                :invalid
              else
                :available
              end
            else
              Whois.bug!(ParserError, "Unable to parse status.")
            end
          end
        end

        property_supported :available? do
          !invalid? && (!!node("status-available") || node("Status") == "free")
        end

        property_supported :registered? do
          !invalid? && !available?
        end


        property_not_supported :created_on

        property_supported :updated_on do
          node("Changed") { |raw| Time.parse(raw) }
        end

        property_not_supported :expires_on


        property_supported :registrar do
          node("Zone-C") do |raw|
            Record::Registrar.new(
                :id => nil,
                :name => raw["name"],
                :organization => raw["organization"],
                :url => nil
            )
          end
        end

        property_supported :registrant_contacts do
          contact("Holder", Whois::Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          contact("Admin-C", Whois::Record::Contact::TYPE_ADMIN)
        end

        # FIXME: check against different schema

        property_supported :technical_contacts do
          contact("Tech-C", Whois::Record::Contact::TYPE_TECHNICAL)
        end


        # Nameservers are listed in the following formats:
        #
        #   Nserver:     ns1.prodns.de. 213.160.64.75
        #   Nserver:     ns1.prodns.de.
        #
        property_supported :nameservers do
          node("Nserver") do |values|
            values.map do |line|
              name, ipv4 = line.split(/\s+/)
              Record::Nameserver.new(name.chomp("."), ipv4)
            end
          end
        end


        # Checks whether the response has been throttled.
        #
        # @return [Boolean]
        #
        # @example
        #   % Error: 55000000002 Connection refused; access control limit reached.
        #
        def response_throttled?
          !!node("response-throttled")
        end


        # NEWPROPERTY
        def version
          cached_properties_fetch :version do
            if content_for_scanner =~ /^% Version: (.+)$/
              $1
            end
          end
        end

        # NEWPROPERTY
        def invalid?
          cached_properties_fetch :invalid? do
            !!node("status-invalid") || node("Status") == "invalid"
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
              Record::Contact.new(raw) do |c|
                c.type = type
              end
            end
          end


          class Scanner < Scanners::Base

            def parse_content
              parse_throttled   ||
              parse_disclaimer  ||
              parse_invalid     ||    # 1.10.0, 1.11.0
              parse_available   ||    # 1.10.0, 1.11.0
              parse_pair(@ast)  ||
              parse_contact     ||
              parse_db_time     ||    # 2.0

              trim_empty_line   ||
              error!("Unexpected token")
            end


            def parse_throttled
              if @input.match?(/^% Error: 55000000002/)
                @ast["response-throttled"] = true
                @input.skip(/^.+\n/)
              end
            end

            def parse_disclaimer
              if @input.match?(/% Copyright \(c\) *\d{4} by DENIC\n/)
                @input.scan_until(/% Terms and Conditions of Use\n/)
                lines = []
                while @input.match?(/%/) && @input.scan(/%(.*)\n/)
                  lines << @input[1].strip unless @input[1].strip == ""
                end
                @ast["Disclaimer"] = lines.join(" ")
              end
            end

            def parse_pair(node)
              if @input.scan(/([^  \[]*):(.*)\n/)
                key, value = @input[1].strip, @input[2].strip
                if node[key].nil?
                  node[key] = value
                else
                  node[key].is_a?(Array) || node[key] = [node[key]]
                  node[key] << value
                end
                true
              end
            end

            def parse_contact
              if @input.scan(/\[(.*)\]\n/)
                contact_name = @input[1]
                contact = {}
                while parse_pair(contact)
                end
                @ast[contact_name] = {
                  "id" => nil,
                  "name" => contact['Name'],
                  "organization" => contact['Organisation'],
                  "address" => contact['Address'],
                  "city" => contact['City'],
                  # 1.10.0, 1.11.0 || 2.0
                  "zip" => contact['Pcode'] || contact['PostalCode'],
                  "state" => nil,
                  "country" => contact['Country'],
                  "country_code" => contact['CountryCode'],
                  "phone" => contact['Phone'],
                  "fax" => contact['Fax'],
                  "email" => contact['Email'],
                  "created_on" => nil,
                  "updated_on" => contact['Changed']
                }
              end
            end

            # Compatibility with Version: 1.11.0, 1.10.0
            def parse_available
              if @input.match?(/% Object ".+" not found in database\n/)
                while @input.scan(/%(.*)\n/)  # strip junk
                end
                @ast["status-available"] = true
              end
            end

            def parse_invalid
              if @input.match?(/% ".+" is not a valid domain name\n/)
                @input.scan(/% "(.+?)" is not a valid domain name\n/)
                @ast["Domain"] = @input[1]
                @ast["status-invalid"] = true
              end
            end

            def parse_db_time
              @input.scan(/^% DB time is (.+)\n$/)
            end

          end

      end
    end
  end
end
