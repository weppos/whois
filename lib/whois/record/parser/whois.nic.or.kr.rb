require 'whois/record/parser/base'
require 'whois/record/scanners/whois.nic.or.kr.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.it server.
      class WhoisNicOrKr < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisNicOrKr

        property_supported :registrar do
          Record::Registrar.new(
              name: node('Service Name'),
              id: node('Organization ID'),
              organization: node('Organization Name')
          )
        end
      end
    end
  end
end
