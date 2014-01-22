#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/scanners/base'


module Whois
  class Record
    module Scanners

      class Iana < Base

        self.tokenizers += [
            :skip_empty_line,
            :scan_disclaimer,
            :scan_section,
        ]


        tokenizer :scan_disclaimer do
          if @input.match?(/^\%(.*?)\n/)
            @ast["Disclaimer"] = _scan_lines_to_array(/\%(.*?)\n/).select { |line| line =~ /\w+/ }.join(" ")
          end
        end

        tokenizer :scan_section do
          if @input.scan(/^(.+):(.+)\n/)

            # Adapt the section's name depending on the first line
            section = case @input[1].strip
            when 'contact'
              @input[2].strip # use the contact type name as identifier
            when 'created', 'changed'
              'dates'
            when 'nserver'
              'nameservers'
            else
              @input[1].strip # Default name is the first label found
            end

            content = parse_section_pairs
            @input.match?(/\n+/) || error("Unexpected end of section")
            @ast[section] = content
          end
        end


      private

        def parse_section_pairs
          # Sets by default the firsts values found in the section parsing bellow
          section_name, section_value = @input[1].strip, @input[2].strip
          #contents = {section_name =>  section_value}

          contents = {}

          while content = parse_section_pair
            contents.merge!(content)
          end

          if contents.has_key? section_name
            contents[section_name].insert(0, "#{section_value}\n")
          else
            contents[section_name] = section_value
          end

          if !contents.empty?
            contents
          else
            false
          end
        end

          def parse_section_pair
            if @input.scan(/^(.+):\s*(.+)\n/)
              key     =  @input[1].strip
              values  = [@input[2].strip]

              while value = parse_section_pair_newlinevalue(key)
                values << value
              end
              { key => values.join("\n") }
            end
          end

            def parse_section_pair_newlinevalue(key)
              if @input.scan(/^#{key}:\s*(.+)\n/)
                @input[1].strip
              end
            end

      end
    end
  end
end