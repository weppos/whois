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

      class WhoisRegistryNetZa < Base
        self.tokenizers += [
            :scan_availability,
            :scan_domain,
            :scan_registrant_details,
            :scan_registrant_address,
            :scan_registrar_details,
            :scan_dates,
            :scan_status,
            :scan_pending_timer_events,
            :scan_nameservers,
            :scan_disclaimer
        ]

        tokenizer :scan_availability do
          if @input.scan_until(/^Available\n$/m)
            @ast["status:available"] = true
          end
        end

        tokenizer :scan_domain do
          if find_heading("Domain Name")
            @ast["node:domain"] = content_in_category
          end
        end

        tokenizer :scan_registrant_details do
          if find_heading("Registrant")
            @ast["node:registrant_details"] = content_in_category
          end
        end

        tokenizer :scan_registrant_address do
          if find_heading("Registrant's Address")
            @ast["node:registrant_address"] = content_in_category
          end
        end

        tokenizer :scan_registrar_details do
          if find_heading("Registrar")
            @ast["node:registrar"] = content_in_category
          end
        end

        tokenizer :scan_dates do
          if find_heading("Relevant Dates")
            @ast["node:dates"] = content_in_category
          end
        end

        tokenizer :scan_status do
          if find_heading("Domain Status")
            @ast["node:status"] = content_in_category
          end
        end

        tokenizer :scan_pending_timer_events do
          if find_heading("Pending Timer Events")
            @ast["node:pending_timer_events"] = content_in_category
          end
        end

        tokenizer :scan_nameservers do
          if find_heading("Name Servers")
            @ast["node:nameservers"] = content_in_category
          end
        end

        tokenizer :scan_disclaimer do
          @input.skip_until(/\n--\n/m)
          @ast["node:disclaimer"] = @input.scan_until(/.*$/m)
        end

        private

        def content_in_category
          lines = _scan_lines_to_array(/    (.*)\n/)
          lines.size == 1 ? lines.first : lines
        end

        def find_heading(heading_name)
          @input.skip_until(/    #{heading_name}:\n/)
        end
      end

    end
  end
end
