#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Gábor Vészi <veszig@done.hu>, Simone Carletti <weppos@weppos.net>
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
      # = whois.nic.hu parser
      #
      # Parser for the whois.nic.hu server.
      #
      class WhoisNicHu < Base
        include Ast

        property_supported :disclaimer do
          node('Disclaimer')
        end


        property_supported :domain do
          node('Domain')
        end

        property_supported :domain_id do
          node('hun-id')
        end


        property_supported :status do
          if node('NotFound')
            :available
          elsif node('InProgress')
            :in_progress
          else
            :registered
          end
        end

        property_supported :available? do
          @available ||= status == :available
        end

        property_supported :registered? do
          @registered ||= status == :registered
        end


        property_supported :created_on do
          node('registered') { |raw| Time.parse(raw) }
        end

        property_supported :updated_on do
          node('changed') { |raw| Time.parse(raw) }
        end

        property_not_supported :expires_on


        property_supported :registrar do
          if c = registrar_contact
            Answer::Registrar.new(
              :id => c[:id],
              :name => c[:name],
              :organization => c[:organization]
            )
          end
        end

        property_supported :registrant_contact do
          return unless registered?
          return @registrant_contact if @registrant_contact

          address, city, zip, country_code = decompose_address(node("address"))

          @registrant_contact = Whois::Answer::Contact.new(
            :type         => Whois::Answer::Contact::TYPE_REGISTRANT,
            :name         => node("name"),
            :organization => node("org"),
            :address      => address,
            :city         => city,
            :zip          => zip,
            :country_code => country_code,
            :phone        => node("phone"),
            :fax          => node("fax-no")
          )
        end

        property_supported :admin_contact do
          @admin_contact ||= contact("admin-c", Whois::Answer::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contact do
          @tecnical_contact ||= contact("tech-c", Whois::Answer::Contact::TYPE_TECHNICAL)
        end

        # @deprecated
        register_property :registrant, :supported
        # @deprecated
        register_property :admin, :supported
        # @deprecated
        register_property :technical, :supported


        property_supported :nameservers do
          @nameservers ||= node("nameserver") || []
        end


        def registrar_contact
          contact("registrar", nil)
        end

        def zone_contact
          contact("zone-c", nil)
        end


        protected

          def parse
            Scanner.new(content_for_scanner).parse
          end

          def contact(element, type)
            node(node(element)) do |raw|
              Whois::Answer::Contact.new do |c|
                c.type = type
                raw.each { |k,v| c[k.to_sym] = v }
              end
            end
          end

          # Depending on record type, the address can be <tt>nil</tt>
          # or an array containing different address parts.
          def decompose_address(parts)
            addresses = parts || []
            address, city, zip, country_code = nil, nil, nil, nil

            if !addresses.empty?
              address       = addresses[0]                if addresses[0]
              zip, city     = addresses[1].split(" ", 2)  if addresses[1]
              country_code  = addresses[2]                if addresses[2]
            end

            [address, city, zip, country_code]
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

            def trim_newline
              @input.scan(/\n/)
            end

            def parse_content
              parse_disclaimer  ||
              parse_domain      ||
              parse_not_found   ||
              parse_in_progress ||
              parse_domain_data ||
              parse_contacts    ||
              trim_newline      ||
              error("Unexpected token")
            end

            def parse_disclaimer
              if @input.match?(/% Whois server .*\n/)
                @input.scan_until(/\n\n/)
                lines = []
                while @input.match?(/\S+/) && @input.scan(/(.*)\n/)
                  lines << @input[1].strip
                end
                @ast['Disclaimer'] = lines.join("\n")
                true
              end
              false
            end

            def parse_domain
              if @input.match?(/\ndomain:\s+\S+\n/) && @input.scan(/\ndomain:\s+(\S+)\n/)
                @ast['Domain'] = @input[1].strip
                true
              end
              false
            end

            # FIXME: Requires UTF-8 Encoding (see #11)
            def parse_not_found
              if @input.match?(/\nNincs (.*?) \/ No match\n/)
                @input.scan(/\nNincs (.*?) \/ No match\n/)
                return @ast['NotFound'] = true
              end
              @ast['NotFound'] = false
            end

            # FIXME: Requires UTF-8 Encoding (see #11)
            def parse_in_progress
              if @input.match?(/(.*?) folyamatban \/ Registration in progress\n/)
                 @input.scan(/(.*?) folyamatban \/ Registration in progress\n/)
                 return @ast['InProgress'] = true
              end
              @ast['InProgress'] = false
            end

            def parse_domain_data
              if @input.match?(/\S+:\s+.*\n/)
                while @input.match?(/\S+:\s+.*\n/) && @input.scan(/(\S+):\s+(.*)\n/)
                  key, value = @input[1].strip, @input[2].strip
                  if key == 'person'
                    @ast['name'] = value
                  elsif key == 'org'
                    if value =~ /org_name_hun:\s+(.*)\Z/
                      @ast['name'] = $1
                    elsif value =~ /org_name_eng:\s+(.*)\Z/
                      @ast['org'] = $1
                    elsif value != 'Private person'
                      contact['org'] = value
                    end
                  elsif @ast[key].nil?
                    @ast[key] = value
                  elsif @ast[key].is_a? Array
                    @ast[key] << value
                  else
                    @ast[key] = [@ast[key], value].flatten
                  end
                end
                true
              end
              false
            end

            def parse_contacts
              if @input.match?(/\n\S+:\s+.*\n/)
                while @input.match?(/\n\S+:\s+.*\n/)
                  @input.scan(/\n/)
                  parse_contact
                end
                true
              else
                false
              end
            end

            def parse_contact
              if @input.match?(/\S+:\s+.*\n/)
                contact ||= {}
                while @input.match?(/\S+:\s+.*\n/) && @input.scan(/(\S+):\s+(.*)\n/)
                  key, value = @input[1].strip, @input[2].strip
                  if key == 'hun-id'
                    a1 = contact['address'][1].split(/\s/)
                    zip = a1.shift
                    city = a1.join(' ')
                    # we should keep the old values if this is an already
                    # defined contact
                    if @ast[value].nil?
                      @ast[value] = {
                        "id" => value,
                        "name" => contact['name'],
                        "organization" => contact['org'],
                        "address" => contact['address'][0],
                        "city" => city,
                        "zip" => zip,
                        "country_code" => contact['address'][2],
                        "phone" => contact['phone'],
                        "fax" => contact['fax-no'],
                        "email" => contact['e-mail']
                      }
                    else
                      @ast[value]["id"] ||= value
                      @ast[value]["name"] ||= contact['name']
                      @ast[value]["organization"] ||= contact['org']
                      @ast[value]["address"] ||= contact['address'][0]
                      @ast[value]["city"] ||= city
                      @ast[value]["zip"] ||= zip
                      @ast[value]["country_code"] ||= contact['address'][2]
                      @ast[value]["phone"] ||= contact['phone']
                      @ast[value]["fax"] ||= contact['fax-no']
                      @ast[value]["email"] ||= contact['e-mail']
                    end
                    contact = {}
                  elsif key == 'person'
                    contact['name'] = value
                  elsif key == 'org'
                    if value =~ /org_name_hun:\s+(.*)\Z/
                      contact['name'] = $1
                    elsif value =~ /org_name_eng:\s+(.*)\Z/
                      contact['org'] = $1
                    else
                      contact['org'] = value
                    end
                  elsif key == 'address' && !contact['address'].nil?
                    contact['address'] = [contact['address'], value].flatten
                  else
                    contact[key] = value
                  end
                end
                true
              end
              false
            end

            def error(message)
              raise "#{message}: #{@input.peek(@input.string.length)}"
            end

        end
        
      end

    end
  end
end