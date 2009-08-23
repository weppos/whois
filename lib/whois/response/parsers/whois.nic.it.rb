#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client.
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


require 'whois/response/parsers/base'


module Whois
  class Response
    module Parsers

      #
      # = whois.nic.it parser
      #
      # Parser for the whois.nic.it server.
      #
      class WhoisNicIt < Base

        def disclaimer
          node("Disclaimer")
        end


        def domain
          node("Domain").downcase
        end

        def domain_id
          nil
        end
        

        def status
          node("Status").downcase.to_sym
        end
        
        def available?
          node("Status") == "AVAILABLE"
        end
        
        def registered?
          !available?
        end
        
        
        def created_on
          node("Created") { |raw| Time.parse(raw) }
        end
        
        def updated_on
          node("Last Update") { |raw| Time.parse(raw) }
        end
        
        def expires_on
          node("Expire Date") { |raw| Time.parse(raw) }
        end


        def registrar
          node("Registrar") do |raw|
            Response::Registrar.new(
              :id           => raw["Name"],
              :name         => raw["Name"],
              :organization => raw["Organization"]
            )
          end
        end

        def registrant
          contact("Registrant")
        end

        def admin
          contact("Admin Contact")
        end

        def technical
          contact("Technical Contacts")
        end


        def nameservers
          node("Nameservers")
        end


        protected

          def contact(element)
            node(element) do |raw|
              address = (raw["Address"] || "").split("\n")
              Response::Contact.new(
                :id           => raw["ContactID"],
                :name         => raw["Name"],
                :organization => raw["Organization"],
                :address      => address[0],
                :city         => address[1],
                :country_code => address[3],
                :created_on   => raw["Created"] ? Time.parse(raw["Created"]) : nil,
                :updated_on   => raw["Last Update"] ? Time.parse(raw["Created"]) : nil
              )
            end
          end

          def parse
            @input = StringScanner.new(@response.to_s)
            @ast = {}
            while !@input.eos?
              trim_newline  ||
              parse_content
            end
            @ast
          end

          def ast
            @ast || parse
          end

          def node(key, &block)
            if block_given?
              value = ast[key]
              value = yield(value) unless value.nil?
              value
            else
              ast[key]
            end
          end

          def node?(key)
            !ast[key].nil?
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