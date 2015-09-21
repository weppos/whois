require 'whois/record/parser/base'
require 'whois/record/scanners/whois.lacnic.net.rb'

module Whois
  class Record
    class Parser

      #
      # = whois.lacnic.net parser
      #
      # Parser for the whois.lacnic.net server.

      class WhoisLacnicNet < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisLacnicNet

        property_supported :registrar do
          Record::Registrar.new(
              id:           node('ownerid'),
              name:         node('owner'),
              organization: node('owner'),
          )
        end
      end
    end
  end
end
