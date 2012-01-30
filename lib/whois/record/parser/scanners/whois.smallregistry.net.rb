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

        class WhoisSmallregistryNet < Base

          self.tokenizers += [
            :scan_yaml_header,
            :scan_disclaimer,
            :scan_request_time,
            :scan_not_found,
            :scan_domain,
            :scan_status,
            :scan_date_created,
            :scan_date_expired,
            :scan_date_updated,
            :scan_name_servers,
            :scan_ds_list,
            :scan_registrar,
            :scan_registrant,
            :scan_administrative_contact,
            :scan_technical_contact,
            :scan_billing_contact,
          ]

          tokenizer :scan_yaml_header do
            # skip the YAML prelude
            @input.scan(/^---.*\n/)
          end

          tokenizer :scan_disclaimer do
            if @input.match?(/^#/) && disc = @input.scan_until(/^#\n/)
              @ast["field:disclaimer"] = disc
            end
          end

          tokenizer :scan_request_time do
            if @input.scan(/^# (\d+-\d+-\d+T.*)\n/)
              @ast["field:request_time"] = @input[1].strip
            end
          end

          tokenizer :scan_not_found do
            if @input.scan(/^# Object not found.*\n/)
              @ast["status:available"] = true
            end

          end

          tokenizer :scan_domain do
            if @input.match?(/^name:\s+(.*)\n/) && @input.scan(/^name:\s+(.*?)\n/)
              @ast["field:domain"] = @input[1].strip
            end
          end

          tokenizer :scan_status do
            if @input.match?(/^status:\s+(.*)\n/) && @input.scan(/^status:\s+(.*?)\n/)
              @ast["field:status"] = @input[1].strip.downcase
            end
          end

          %w(created expired updated).each do |date|
            tokenizer :"scan_date_#{date}" do
              if @input.match?(/^#{date}:\s+"(.*)"\n/) && @input.scan(/^#{date}:\s+"(.*)"\n/)
                @ast["field:#{date}"] = @input[1].strip
              end
            end
          end

          tokenizer :scan_name_servers do
            if @input.match?(/^name_servers: $\n/) && @input.scan(/^name_servers: \n/)
              @ast["field:nameservers"] = []
              while line = @input.scan(/^- (\S+)(?: - (.*?)(?: - (.*?))?)?\n/)
                @ast["field:nameservers"] << { :name => @input[1], :ipv4 => @input[2], :ipv6 => @input[3] }
              end
            end
          end

          tokenizer :scan_ds_list do
            if @input.match?(/^ds-list: $/) && @input.scan(/^ds-list: \n/)
              @ast["field:ds"] = []
              while line = @input.scan(/^- (.*)\n/)
                @ast["field:ds"] << @input[1].strip
              end
            end
          end

          tokenizer :scan_registrar do
            if @input.match?(/^registrar: /) && @input.scan(/^registrar: .*\n/)
              registrar = {}
              %w(name address phone fax mobile web trouble).each do |field|
                ret = parse_string(field, 2)
                registrar[field] = ret unless ret.nil?
              end
              @ast["field:registrar"] = registrar
            end
          end

          {
            'registrant' => Whois::Record::Contact::TYPE_REGISTRANT,
            'administrative_contact' => Whois::Record::Contact::TYPE_ADMIN,
            'technical_contact' => Whois::Record::Contact::TYPE_TECHNICAL,
            'billing_contact' => nil,
          }.each do |type, id|
            tokenizer :"scan_#{type}" do
              if @input.match?(/^#{type}: /) && @input.scan(/^#{type}: .*\n/)
                contact = {:type => id}
                [
                  ['nic-handle', :id],
                  ['name', :name],
                  ['company', :organization],
                  ['type', nil],
                  ['address', :address],
                  ['phone', :phone],
                  ['fax', :fax],
                  ['mobile', nil],
                ].each do |k,v|
                  ret = parse_string(k, 2)
                  contact[v] = ret.strip unless ret.nil? || v.nil?
                end
                if @input.match?(/^  updated:\s+"(.*)"\n/) && @input.scan(/^  updated:\s+"(.*)"\n/)
                  contact[:updated_on] = DateTime.parse(@input[1].strip)
                end
                @ast["field:#{type}"] = contact
              end
            end
          end

          private
          
          def parse_string(k, spaces = 0)
            if @input.match?(/^#{" "*spaces}#{k}: \|-/) && @input.scan(/^#{" "*spaces}#{k}: .*\n/)
              val = ""
              while line = @input.scan(/^#{" "*(spaces+2)}.*\n/)
                val << line.sub(/^#{" "*(spaces+2)}/, '')
              end
              val.chomp
            elsif @input.match?(/^#{" "*spaces}#{k}: /) && @input.scan(/^#{" "*spaces}#{k}: ("?)(.*)\1\n/)
              @input[2]
            end
          end
        
      end
      end
    end
  end
end
