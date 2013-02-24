#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/scanners/base'


module Whois
  class Record
    module Scanners

      class WhoisNicHu < Base

        self.tokenizers += [
            :scan_version,
            :scan_disclaimer,
            :scan_domain,
            :scan_available,
            :scan_in_progress,

            # v2.0
            :scan_moreinfo,

            # v1.99
            :scan_domain_data,
            :scan_contacts,

            :skip_empty_line,
        ]


        # FIXME: Requires UTF-8 Encoding (see #11)
        tokenizer :scan_available do
          if @input.match?(/Nincs (.*?) \/ No match\n/)
            @input.skip(/Nincs (.*?) \/ No match\n/)
            @ast["status:available"] = true
          end
        end

        # FIXME: Requires UTF-8 Encoding (see #11)
        tokenizer :scan_in_progress do
          if @input.match?(/(.*?) folyamatban \/ Registration in progress\n/)
            @input.skip(/(.*?) folyamatban \/ Registration in progress\n/)
            @ast["status:inprogress"] = true
          end
        end

        tokenizer :scan_disclaimer do
          if @input.match?(/^Rights.*\n/)
            lines = @input.scan_until(/^\n/)
            @ast["field:disclaimer"] = lines.strip
          end
        end

        tokenizer :scan_domain do
          if @input.match?(/^domain:\s+(.*)\n/) && @input.scan(/^domain:\s+(.*?)\n/)
            @ast["field:domain"] = @input[1].strip
          end
        end

        # FIXME: Requires UTF-8 Encoding (see #11)
        tokenizer :scan_moreinfo do
          if @input.match?(/Tov.* ld\.:\n/)
            @ast["field:moreinfo"] = @input.scan_until(/^\n/)
          end
        end

        tokenizer :scan_version do
          if @input.match?(/% Whois server .*\n/)
            @input.scan(/% Whois server ([\w\d\.]*).*?\n/)
            @ast["field:version"] = @input[1]
          end
        end

        tokenizer :scan_domain_data do
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

        tokenizer :scan_contacts do
          if @input.match?(/\n(person|org):/)
            @input.scan(/\n/)
            while @input.match?(/(.+?):\s+(.*)\n/)
              parse_contact
            end
            true
          end
        end


      private

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
