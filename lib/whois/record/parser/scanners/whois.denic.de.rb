#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/scanners/base'


module Whois
  class Record
    class Parser
      module Scanners

        class WhoisDenicDe < Scanners::Base

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
