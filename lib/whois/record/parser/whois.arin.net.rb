require 'whois/record/parser/base'
require 'whois/record/scanners/whois.arin.net.rb'

module Whois
  class Record
    class Parser

      # = whois.arin.net parser
      #
      # Parser for the whois.arin.net server.

      class WhoisArinNet < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisArinNet

        property_supported :registrar do
          Record::Registrar.new(
              id:           node("OrgId"),
              name:         node("OrgName"),
              organization: node("Organization")
          )
        end

        property_supported :created_on do
          node('RegDate')
        end

        property_supported :updated_on do
          node('Updated')
        end

        property_not_supported :expires_on
      end
    end
  end
end
