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

        # Returns the registry disclaimer that comes with the response.
        def disclaimer
          node("Disclaimer")
        end


        # If available, returns the domain name as stored by the registry.
        def domain
          node("Domain") { |raw| raw.downcase }
        end

        # If available, returns the unique domain ID set by the registry.
        def domain_id
          nil
        end
        

        # Returns the record status or an array of status,
        # in case the registry supports it.
        def status
          node("Status") { |raw| raw.downcase.to_sym }
        end
        
        # Returns whether this record is available.
        def available?
          node("Status") == "AVAILABLE"
        end
        
        # Returns whether this record is registered.
        def registered?
          !available?
        end
        

        # If available, returns a Time object representing the date
        # the record was created, according to the registry response.
        def created_on
          node("Created") { |raw| Time.parse(raw) }
        end
        
        # If available, returns a Time object representing the date
        # the record was last updated, according to the registry response.
        def updated_on
          node("Last Update") { |raw| Time.parse(raw) }
        end
        
        # If available, returns a Time object representing the date
        # the record is set to expire, according to the registry response.
        def expires_on
          node("Expire Date") { |raw| Time.parse(raw) }
        end


        # If available, returns a <tt>Whois::Response::Registrar</tt> record
        # containing the registrar details extracted from the registry response.
        def registrar
          node("Registrar") do |raw|
            Response::Registrar.new(
              :id           => raw["Name"],
              :name         => raw["Name"],
              :organization => raw["Organization"]
            )
          end
        end

        # If available, returns a <tt>Whois::Response::Contact</tt> record
        # containing the registrant details extracted from the registry response.
        def registrant
          contact("Registrant")
        end

        # If available, returns a <tt>Whois::Response::Contact</tt> record
        # containing the admin contact details extracted from the registry response.
        def admin
          contact("Admin Contact")
        end

        # If available, returns a <tt>Whois::Response::Contact</tt> record
        # containing the technical contact details extracted from the registry response.
        def technical
          contact("Technical Contacts")
        end


        # If available, returns an array of name servers entries for this domain
        # if any name server is available in the registry response.
        # Each name server is a lower case string.
        #
        # ==== Examples
        #
        #   nameserver
        #   # => nil
        #   nameserver
        #   # => ["ns2.google.com", "ns1.google.com", "ns3.google.com"]
        #
        def nameservers
          node("Nameservers")
        end


#        # Returns whether this response is equal to <tt>other</tt>.
#        #
#        # Comparing the Response contents is not always as trivial as it seems.
#        # Whois servers sometimes inject dynamic method into the whois response such as
#        # the timestamp the request was generated.
#        # This causes two responses to be different even if they actually should be considered equal
#        # because the registry data didn't change.
#        #
#        # This method should provide a bulletproof way to detect whether this response
#        # changed if compared with <tt>other</tt>.
#        def equals?(other)
#          self == other ||
#          self.response.to_s == other.response.to_s
#          # domain     == other.domain     &&
#          # created_on == other.created_on &&
#          # updated_on == other.updated_on &&
#          # expires_on == other.expires_on
#        end


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