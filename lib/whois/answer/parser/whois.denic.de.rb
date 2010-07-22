#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Aaron Mueller <mail@aaron-mueller.de>, Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'


module Whois
  class Answer
    class Parser
      class WhoisDenicDe < Base
        include Ast

        property_supported :disclaimer do
          node("Disclaimer")
        end


        property_supported :domain do
          node("Domain")
        end

        property_not_supported :domain_id


        property_supported :status do
          node("Status")
        end

        property_supported :available? do
          node("NotFound") && !node("Invalid")
        end

        property_supported :registered? do
          !(node("NotFound") || node("Invalid"))
        end


        property_not_supported :created_on

        property_supported :updated_on do
          node("Changed") { |raw| Time.parse(raw) }
        end

        property_not_supported :expires_on


        property_supported :registrar do
          node("Zone-C") do |raw|
            Answer::Registrar.new(
                :id => nil,
                :name => raw["name"],
                :organization => raw["organization"],
                :url => nil
            )
          end
        end

        property_supported :registrant_contact do
          @registrant_contact ||= contact("Holder", Whois::Answer::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contact do
          @admin_contact ||= contact("Admin-C", Whois::Answer::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contact do
          @technical_contact ||= contact("Tech-C", Whois::Answer::Contact::TYPE_TECHNICAL)
        end

        # @deprecated
        register_property :registrant, :supported
        # @deprecated
        register_property :admin, :supported
        # @deprecated
        register_property :technical, :supported


        # Nameservers are listed in the following formats:
        # 
        #   Nserver:     ns1.prodns.de 213.160.64.75
        #   Nserver:     ns1.prodns.de
        # 
        # In both cases, always return only the name.
        property_supported :nameservers do
          @nameservers ||= node("Nserver") do |values|
            values.map do |value|
              value.split(" ").first
            end
          end
          @nameservers ||= []
        end


        protected

          def parse
            Scanner.new(content_for_scanner).parse
          end

          def contact(element, type)
            node(element) do |raw|
              Answer::Contact.new(raw) do |c|
                c.type = type
              end
            end
          end


        class Scanner

          def initialize(content)
            @input = StringScanner.new(content)
          end

          def parse
            @ast = {}
            while !@input.eos?
#              trim_empty_line  ||
              parse_content
            end
            @ast
          end

          private

            def parse_content
              parse_disclaimer  ||
              parse_invalid     ||
              parse_not_found   ||
              parse_pair(@ast)  ||
              parse_contact     ||

              trim_empty_line   ||
              error("Unexpected token")
            end
  
            def trim_empty_line
              @input.skip(/^\n/)
            end

            def error(message)
              if @input.eos?
                raise "Unexpected end of input."
              else
                raise "#{message}: `#{@input.peek(@input.string.length)}'"
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
                true
              end
              false
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
              else
                false
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
                  "zip" => contact['Pcode'],
                  "state" => nil,
                  "country" => nil,
                  "country_code" => contact['Country'],
                  "phone" => contact['Phone'],
                  "fax" => contact['Fax'],
                  "email" => contact['Email'],
                  "created_on" => nil,
                  "updated_on" => contact['Changed']
                }
                true
              else
                false
              end
            end

            def parse_not_found
              if @input.match?(/% Object "(.*)" not found in database\n/)
                while @input.scan(/%(.*)\n/)  # strip junk
                end
                @ast["NotFound"] = true
              end
            end

            def parse_invalid
              if @input.match?(/% ".*" is not a valid domain name\n/)
                @input.scan(/%.*\n/)
                @ast["Invalid"] = true
              end 
            end

        end

      end
    end
  end
end
