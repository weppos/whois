#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/scanners/whois.nic-se.se.rb'

module Whois
  class Record
    class Parser

      #
      # = whois.nic-se.se
      #
      # Parser for the whois.nic-se.se server.
      #
      # @author Simone Carletti <weppos@weppos.net>
      # @author Mikkel Kristensen <mikkel@tdx.dk>
      # @author Pieter Agten <pieter.agten@gmail.com>
      #
      class WhoisNicSeSe < Base
        include Scanners::Scannable

        self.scanner = Scanners::WhoisNicSeSe

        property_supported :disclaimer do
          node("disclaimer")
        end

        property_supported :status do
          if available?
            :available
          else
            Array.wrap(node("status"))
          end
        end

        property_supported :available? do
          !!node("not_found")
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          node("created") { |value| Time.parse(value) }
        end

        property_supported :expires_on do
          node("expires") { |value| Time.parse(value) }
        end

        property_supported :updated_on do
          node("modified") { |value| Time.parse(value) unless value == '-'}
        end


        # Nameservers are listed in the following formats:
        #
        #   nserver:  ns2.loopia.se
        #   nserver:  ns2.loopia.se 93.188.0.21
        #
        property_supported :nameservers do
          node("nserver") do |values|
            values.map do |line|
              name, ipv4 = line.split(/\s+/)
              Record::Nameserver.new(:name => name, :ipv4 => ipv4)
            end
          end
        end

      end

    end
  end
end
