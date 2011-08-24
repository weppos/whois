#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2011 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'
require 'whois/record/parser/scanners/afilias'


module Whois
  class Record
    class Parser

      # Parser for the whois.nic.xxx server.
      class WhoisNicXxx < BaseAfilias

        property_supported :updated_on do
          node("Last Updated On") do |value|
            Time.parse(value) unless value.empty?
          end
        end


        property_supported :registrar do
          node("Sponsoring Registrar") do |value|
            value =~ /(.+?) \((.+?)\)/ || Whois.bug!(ParserError, "Unknown registrar format `#{value}'")
            Record::Registrar.new(
              :id =>            $1,
              :name =>          $2,
              :organization =>  $2
            )
          end
        end

      end

    end
  end
end
