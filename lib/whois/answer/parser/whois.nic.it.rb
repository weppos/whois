#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'
require 'whois/answer/parser/scanners/base'


module Whois
  class Answer
    class Parser

      #
      # = whois.nic.it parser
      #
      # Parser for the whois.nic.it server.
      #
      class WhoisNicIt < Base
        include Features::Ast

        property_supported :disclaimer do
          node("Disclaimer")
        end


        property_supported :domain do
          node("Domain") { |raw| raw.downcase }
        end

        property_not_supported :domain_id


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          case node("Status").to_s.downcase
          when /^ok/, "active"
            :registered
          when /\bclient/
            :registered
          when "pendingdelete / redemptionperiod", "grace-period"
            :registered
          when "available"
            :available
          else
            Whois.bug!(ParserError, "Unknown status `#{node("Status")}'.")
          end
        end

        property_supported :available? do
          node("Status") == "AVAILABLE"
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("Created") { |raw| Time.parse(raw) }
        end

        property_supported :updated_on do
          node("Last Update") { |raw| Time.parse(raw) }
        end

        property_supported :expires_on do
          node("Expire Date") { |raw| Time.parse(raw) }
        end


        property_supported :registrar do
          node("Registrar") do |raw|
            Answer::Registrar.new(
              :id           => raw["Name"],
              :name         => raw["Name"],
              :organization => raw["Organization"]
            )
          end
        end


        property_supported :registrant_contact do
          contact("Registrant", Whois::Answer::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contact do
          contact("Admin Contact", Whois::Answer::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contact do
          contact("Technical Contacts", Whois::Answer::Contact::TYPE_TECHNICAL)
        end


        property_supported :nameservers do
          (node("Nameservers") || []).map do |name|
            Answer::Nameserver.new(name)
          end
        end


        # Initializes a new {Scanner} instance
        # passing the {Whois::Answer::Parser::Base#content_for_scanner}
        # and calls +parse+ on it.
        #
        # @return [Hash]
        def parse
          Scanner.new(content_for_scanner).parse
        end


        protected

          def contact(element, type)
            node(element) do |raw|
              address = (raw["Address"] || "").split("\n")
              Answer::Contact.new(
                :id           => raw["ContactID"],
                :type         => type,
                :name         => raw["Name"],
                :organization => raw["Organization"],
                :address      => address[0],
                :city         => address[1],
                :zip          => address[2],
                :country_code => address[4],
                :created_on   => raw["Created"] ? Time.parse(raw["Created"]) : nil,
                :updated_on   => raw["Last Update"] ? Time.parse(raw["Created"]) : nil
              )
            end
          end


        class Scanner < Scanners::Base

          def parse_content
            trim_newline      ||
            parse_disclaimer  ||
            parse_pair        ||
            parse_section     ||
            error!("Unexpected token")
          end

          def parse_disclaimer
            if @input.match?(/\*(.*?)\*\n/)
              disclaimer = []
              while @input.scan(/\*(.*?)\*\n/)
                matched = @input[1].strip
                disclaimer << matched if matched =~ /\w+/
              end
              @ast["Disclaimer"] = disclaimer.join(" ")
            else
              false
            end
          end

          def parse_pair
            if @input.scan(/(.*?):(.*?)\n/)
              key, value = @input[1].strip, @input[2].strip
              @ast[key] = value
            else
              false
            end
          end

          def parse_section
            if @input.scan(/([^:]*?)\n/)
              section = @input[1].strip
              content = parse_section_pairs ||
                        parse_section_items
              @input.match?(/\n+/) || error("Unexpected end of section")
              @ast[section] = content
            else
              false
            end
          end

            def parse_section_items
              if @input.match?(/(\s+)([^:]*?)\n/)
                items = []
                indentation = @input[1].length
                while item = parse_section_items_item(indentation)
                  items << item
                end
                items
              else
                false
              end
            end

              def parse_section_items_item(indentation)
                if @input.scan(/\s{#{indentation}}(.*)\n/)
                  @input[1]
                else
                  false
                end
              end

            def parse_section_pairs
              contents = {}
              while content = parse_section_pair
                contents.merge!(content)
              end
              if !contents.empty?
                contents
              else
                false
              end
            end

              def parse_section_pair
                if @input.scan(/(\s+)(.*?):(\s+)(.*?)\n/)
                  key = @input[2].strip
                  values = [@input[4].strip]
                  indentation = @input[1].length + @input[2].length + 1 + @input[3].length
                  while value = parse_section_pair_newlinevalue(indentation)
                    values << value
                  end
                  { key => values.join("\n") }
                else
                  false
                end
              end

                def parse_section_pair_newlinevalue(indentation)
                  if @input.scan(/\s{#{indentation}}(.*)\n/)
                    @input[1]
                  else
                    false
                  end
                end

        end

      end

    end
  end
end
