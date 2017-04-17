require 'whois/record/parser/base'
require 'whois/record/scanners/whois.apnic.net.rb'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.it server.
      class WhoisApnicNet < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisApnicNet

        property_supported :registrar do
          Record::Registrar.new(
              name: node('netname')
          )
        end
      end
    end
  end
end
