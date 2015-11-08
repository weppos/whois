require 'whois/record/parser/base'
require 'whois/record/scanners/whois.ripe.net.rb'

module Whois
  class Record
    class Parser

      # = whois.ripe.net parser
      class WhoisRipeNet < Base
        include Scanners::Scannable
        self.scanner = Scanners::WhoisRipeNet

        property_not_supported :created_on
        property_not_supported :expires_on
        property_not_supported :updated_on

        property_supported :status do
          if available?
            :available
          else
            :registered
          end
        end

        property_supported :available? do
          !!(content_for_scanner =~ /%ERROR:101: no entries found/)
        end

        property_supported :registered? do
          !available?
        end

        # Nameservers are listed in the following formats:
        #
        #   nserver:      ns.nic.mc
        #   nserver:      ns.nic.mc 195.78.6.131
        #
        property_supported :nameservers do
          content_for_scanner.scan(/nserver:\s+(.+)\n/).flatten.map do |line|
            name, ipv4 = line.split(/\s+/)
            Record::Nameserver.new(:name => name.downcase, :ipv4 => ipv4)
          end
        end

        property_supported :domain_handle do
          build_handle(:domain_handle)
        end

        property_supported :person_handle do
          build_handle(:person_handle)
        end

        property_supported :organisation_handle do
          build_handle(:organisation_handle)
        end

        property_supported :role_handle do
          build_handle(:role_handle)
        end

        property_supported :maintainer_handle do
          build_handle(:maintainer_handle)
        end

        private
        def build_handle(handle_type)
          node(handle_type) do |hash|
            handle = Record::Handle.new('rpsl', handle_type, hash)
          end
        end
      end
    end
  end
end
