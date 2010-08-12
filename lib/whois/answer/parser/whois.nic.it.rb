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


module Whois
  class Answer
    class Parser

      #
      # = whois.nic.it parser
      #
      # Parser for the whois.nic.it server.
      #
      class WhoisNicIt < Base
        include Ast

        property_supported :disclaimer do
          @disclaimer ||= node("Disclaimer")
        end


        property_supported :domain do
          @domain ||= node("Domain") { |raw| raw.downcase }
        end

        property_not_supported :domain_id


        property_not_supported :referral_whois

        property_not_supported :referral_url


        property_supported :status do
          @status ||= node("Status") { |raw| raw.downcase.to_sym }
        end

        property_supported :available? do
          @available  ||= node("Status") == "AVAILABLE"
        end

        property_supported :registered? do
          @registered ||= !available?
        end


        property_supported :created_on do
          @created_on ||= node("Created") { |raw| Time.parse(raw) }
        end

        property_supported :updated_on do
          @updated_on ||= node("Last Update") { |raw| Time.parse(raw) }
        end

        property_supported :expires_on do
          @expires_on ||= node("Expire Date") { |raw| Time.parse(raw) }
        end


        property_supported :registrar do
          @registrar ||= node("Registrar") do |raw|
            Answer::Registrar.new(
              :id           => raw["Name"],
              :name         => raw["Name"],
              :organization => raw["Organization"]
            )
          end
        end


        property_supported :registrant_contact do
          @registrant_contact ||= contact("Registrant", Whois::Answer::Contact::TYPE_REGISTRANT)
        end


        property_supported :admin_contact do
          @admin_contact ||= contact("Admin Contact", Whois::Answer::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contact do
          @technical_contact ||= contact("Technical Contacts", Whois::Answer::Contact::TYPE_TECHNICAL)
        end

        # @deprecated
        register_property :registrant, :supported
        # @deprecated
        register_property :admin, :supported
        # @deprecated
        register_property :technical, :supported


        property_supported :nameservers do
          @nameservers ||= node("Nameservers") || []
        end


        property_supported :changed? do |other|
          !unchanged?(other)
        end

        property_supported :unchanged? do |other|
          (self === other) ||
          (self.content == other.content)
        end


        protected

          def parse
            Scanner.new(content_for_scanner).parse
          end

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


        class Scanner

          def initialize(content)
            @input = StringScanner.new(content)
          end

          def parse
            @ast = {}
            while !@input.eos?
              trim_newline  ||
              parse_content
            end
            @ast
          end

          private

            def parse_content
              parse_disclaimer  ||
              parse_pair        ||
              parse_section     ||
              error("Unexpected token")
            end

            def trim_newline
              @input.scan(/\n/)
            end

            def parse_pair
              if @input.scan(/(.*?):(.*?)\n/)
                key, value = @input[1].strip, @input[2].strip
                @ast[key] = value
              else
                false
              end
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

            def error(message)
              if @input.eos?
                raise "Unexpected end of input."
              else
                raise "#{message}: #{@input.peek(@input.string.length)}"
              end
            end

        end

      end

    end
  end
end
