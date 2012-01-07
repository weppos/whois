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

        class WhoisNicHu < Scanners::Base

          def parse_content
            parse_version     ||
            parse_disclaimer  ||
            parse_domain      ||
            parse_available   ||
            parse_in_progress ||

            # v2.0
            parse_moreinfo    ||

            # v1.99
            parse_domain_data ||
            parse_contacts    ||

            trim_empty_line   ||
            unexpected_token
          end


          def parse_version
            if @input.match?(/% Whois server .*\n/)
              @input.scan(/% Whois server ([\w\d\.]*).*?\n/)
              @ast["version"] = @input[1]
            end
          end

          # FIXME: Requires UTF-8 Encoding (see #11)
          def parse_moreinfo
            if @input.match?(/Tov.* ld\.:\n/)
              @ast["moreinfo"] = @input.scan_until(/^\n/)
            end
          end

          def parse_disclaimer
            if @input.match?(/^Rights.*\n/)
              lines = @input.scan_until(/^\n/)
              @ast["disclaimer"] = lines.strip
            end
          end

          def parse_domain
            if @input.match?(/^domain:\s+(.*)\n/) && @input.scan(/^domain:\s+(.*?)\n/)
              @ast["domain"] = @input[1].strip
            end
          end

          # FIXME: Requires UTF-8 Encoding (see #11)
          def parse_available
            if @input.match?(/Nincs (.*?) \/ No match\n/)
              @input.scan(/Nincs (.*?) \/ No match\n/)
              @ast["status:available"] = true
            end
          end

          # FIXME: Requires UTF-8 Encoding (see #11)
          def parse_in_progress
            if @input.match?(/(.*?) folyamatban \/ Registration in progress\n/)
              @input.scan(/(.*?) folyamatban \/ Registration in progress\n/)
              @ast["status:inprogress"] = true
            end
          end

          def parse_domain_data
            if @input.match?(/(.+?):\s+(.*)\n/)
              while @input.scan(/(.+?):\s+(.*)\n/)
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
          end

          def parse_contacts
            if @input.match?(/\n(person|org):/)
              @input.scan(/\n/)
              while @input.match?(/(.+?):\s+(.*)\n/)
                parse_contact
              end
              true
            end
          end

          def parse_contact
            contact ||= {}
            while @input.scan(/(.+?):\s+(.*)\n/)
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

        end

      end
    end
  end
end
