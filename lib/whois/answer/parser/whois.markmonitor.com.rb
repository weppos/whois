#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'


module Whois
  class Answer
    class Parser

      #
      # = whois.markmonitor.com parser
      #
      # Parser for the whois.markmonitor.com server.
      #
      class WhoisMarkmonitorCom < Base

        property_not_supported :status


        # The server seems to provide only information for registered domains
        property_supported :available? do
          false
        end

        property_supported :registered? do
          !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Created on\.+: (.+)\.\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Record last updated on\.+: (.+)\.\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expires on\.+: (.+)\.\n/
            Time.parse($1)
          end
        end


        property_supported :registrar do
          Answer::Registrar.new({
            :name => content_for_scanner[/Registrar Name: (.+)\.\n/, 1],
            :url  => content_for_scanner[/Registrar Homepage: (.+)\.\n/, 1]
          })
        end


        property_supported :nameservers do
          content_for_scanner[/Domain servers in listed order:\n\n((?:\s*[^\s\n]+\n)+)/, 1].each_line.map do |ns|
            Answer::Nameserver.new(ns.strip)
          end
        end

      end

    end
  end
end
