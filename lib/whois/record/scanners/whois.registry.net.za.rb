#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++

require 'whois/record/scanners/base'

module Whois
  class Record
    module Scanners

      class WhoisRegistryNetZa < Base
        self.tokenizers += [
          :get_availability,
          :get_domain_name,
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

        tokenizer :get_domain_name do
          if find_heading("Domain Name")
            @ast["field:domain_name"] = content_in_category
          end
        end

        tokenizer :get_registrant_details do
          if find_heading("Registrant")
            @ast["field:registrant_details"] = content_in_category
          end
        end

        tokenizer :get_registrant_address do
          if find_heading("Registrant's Address")
            @ast["field:registrant_address"] = content_in_category
          end
        end

        tokenizer :get_registrar_details do
          if find_heading("Registrar")
            @ast["field:registrar"] = content_in_category
          end
        end

        tokenizer :get_dates do
          if find_heading("Relevant Dates")
            @ast["field:dates"] = content_in_category
          end
        end

        tokenizer :get_status do
          if find_heading("Domain Status")
            statuses = content_in_category
            @ast["field:status"] = statuses.split(", ")
          end
        end

        tokenizer :get_pending_timer_events do
          if find_heading("Pending Timer Events")
            @ast["field:pending_timer_events"] = content_in_category
          end
        end

        tokenizer :get_nameservers do
          if find_heading("Name Servers")
            @ast["field:nameservers"] = content_in_category
          end
        end

        tokenizer :get_disclaimer do
          @input.skip_until(/\n--\n/m)
          @ast["field:disclaimer"] = @input.scan_until(/.*$/m)
        end

        private

        def content_in_category
          @input.scan_until(/(?=\n    [A-Z])/).strip
        end

        def find_heading(heading_name)
          @input.skip_until(/    #{heading_name}:\n/)
        end
      end
    end
  end
end
