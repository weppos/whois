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

      class WhoisRegistryNetZa < Base
        self.tokenizers += [
          :get_availability,
          :get_domain,
          :get_registrant_details,
          :get_registrant_address,
          :get_registrar_details,
          :get_dates,
          :get_status,
          :get_pending_timer_events,
          :get_nameservers,
          :get_disclaimer
        ]

        tokenizer :get_availability do
          if @input.scan_until(/^Available\n$/m)
            @ast["status:available"] = true
          end
        end

        tokenizer :get_domain do
          if find_heading("Domain Name")
            @ast["node:domain"] = content_in_category
          end
        end

        tokenizer :get_registrant_details do
          if find_heading("Registrant")
            @ast["node:registrant_details"] = content_in_category
          end
        end

        tokenizer :get_registrant_address do
          if find_heading("Registrant's Address")
            @ast["node:registrant_address"] = content_in_category
          end
        end

        tokenizer :get_registrar_details do
          if find_heading("Registrar")
            @ast["node:registrar"] = content_in_category
          end
        end

        tokenizer :get_dates do
          if find_heading("Relevant Dates")
            @ast["node:dates"] = content_in_category
          end
        end

        tokenizer :get_status do
          if find_heading("Domain Status")
            @ast["node:status"] = content_in_category
          end
        end

        tokenizer :get_pending_timer_events do
          if find_heading("Pending Timer Events")
            @ast["node:pending_timer_events"] = content_in_category
          end
        end

        tokenizer :get_nameservers do
          if find_heading("Name Servers")
            @ast["node:nameservers"] = content_in_category
          end
        end

        tokenizer :get_disclaimer do
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
