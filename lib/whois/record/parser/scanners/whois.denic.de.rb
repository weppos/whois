#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/scanners/base'


module Whois
  class Record
    class Parser
      module Scanners

        class WhoisDenicDe < Base

          self.tokenizers += [
              :skip_empty_line,
              :scan_response_throttled,
              :scan_disclaimer,
              :scan_invalid,
              :scan_available,
              :scan_pair,
              :scan_contact,
              :skip_db_time,
          ]


          # Version 1.11.0, 1.10.0
          tokenizer :scan_available do
            if @input.match?(/% Object ".+" not found in database\n/)
              while @input.skip(/%(.*)\n/)
              end
              @ast["status:available"] = true
            end
          end

          # Version 1.11.0, 1.10.0
          tokenizer :scan_invalid do
            if @input.match?(/% ".+" is not a valid domain name\n/)
              @input.scan(/% "(.+?)" is not a valid domain name\n/)
              @ast["Domain"] = @input[1]
              @ast["status:invalid"] = true
            end
          end

          tokenizer :scan_response_throttled do
            if @input.match?(/^% Error: 55000000002/)
              @ast["response:throttled"] = true
              @input.skip(/^.+\n/)
            end
          end

          tokenizer :scan_disclaimer do
            if @input.match?(/% Copyright \(c\) *\d{4} by DENIC\n/)
              @input.scan_until(/% Terms and Conditions of Use\n/)
              lines = []
              while @input.match?(/%/) && @input.scan(/%(.*)\n/)
                lines << @input[1].strip unless @input[1].strip == ""
              end
              @ast["Disclaimer"] = lines.join(" ")
            end
          end

          tokenizer :scan_pair do
            parse_pair(@ast)
          end

          tokenizer :scan_contact do
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

          # Version 2.0
          tokenizer :skip_db_time do
            @input.skip(/^% DB time is (.+)\n/)
          end


        private

          def parse_pair(store)
            if @input.scan(/([^  \[]*):(.*)\n/)
              key, value = @input[1].strip, @input[2].strip
              if store[key].nil?
                store[key] = value
              else
                store[key].is_a?(Array) || store[key] = [store[key]]
                store[key] << value
              end
              store
            end
          end

        end

      end
    end
  end
end
