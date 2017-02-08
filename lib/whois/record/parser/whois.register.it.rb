#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
# Copyright (c) 2012 SophosLabs http://www.sophos.com
#++
require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # Parser for the whois.register.it server.
      #
      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @since 2.4.0
      class WhoisRegisterIt < Base

        @@addr_regex = { 
            "Organization:" => :organization,
            "Name:" => :name,
            "Address:" => :address,
            "City:" => :city,
            "Postal Code:" => :zip,
            "Country:" => :country,
            "Email:" => :email,
            "Fax:" => :fax,
            "Phone:|Tel:" => :phone
        }


        property_not_supported :status

        # The server is contacted only in case of a registered domain.
        property_supported :available? do
          false
        end

        property_supported :registered? do
          !available?
        end

        property_supported :created_on do
          if content_for_scanner =~ /Created on: (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :updated_on do
          if content_for_scanner =~ /Updated on: (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expires on: (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :registrar do
          Record::Registrar.new(
            :name => "REGISTER.IT SPA",
            :organization => "REGISTER.IT SPA",
            :url  => "http://we.register.it"
          )
        end

        property_supported :registrant_contacts do
          build_contact(/^\s*Registrant Name:.+(?=^\s*Administrative Contact)/m, Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact(/^\s*Administrative Contact Organization:.+(?=^\s*Technical Contact Organization)/m, Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact(/^\s*Technical Contact Organization:.+(?=^\s*Primary Name Server Hostname)/m, Record::Contact::TYPE_TECHNICAL)
        end

        property_supported :nameservers do
          if content_for_scanner =~ /(Name Server Hostname:(?:\s*[^\s\n]+\n)+)/
            $1.split("\n").map do |line|
              Record::Nameserver.new(line.split(':')[1].strip)
            end
          end
        end


      private
        #Registrant Name: STUFF
        #Contact: STUFF
        #Registrant Address: STUFF
        #Registrant City: STUFF
        #Registrant Postal Code: STUFF
        #Registrant Country: STUFF
        #Administrative Contact Organization: STUFF
        #Administrative Contact Name: STUFF
        #Administrative Contact Address: STUFF
        #Administrative Contact City: STUFF
        #Administrative Contact Postal Code: STUFF
        #Administrative Contact Country: STUFF
        #Administrative Contact Email: STUFF
        #Administrative Contact Tel: STUFF
        #Technical Contact Organization: STUFF
        #Technical Contact Name: STUFF
        #Technical Contact Address: STUFF
        #Technical Contact City: STUFF
        #Technical Contact Postal Code: STUFF
        #Technical Contact Country: STUFF
        #Technical Contact Email: STUFF
        #Technical Contact Phone: STUFF
        #Technical Contact Fax: STUFF

        def build_contact(element, type)
          match =  content_for_scanner.slice(element)
          return unless match
          pattern = /^.+:\s*/
          contents = match.split("\n").map(&:strip)
          lines = contents[0..-2]
          return if lines.nil? or lines.length < 6
          r = {:type => type}
          lines.each { |line|
            @@addr_regex.each_pair { |re, k|
                if Regexp.new(re).match(line)
                  r[k] = line.gsub(pattern, '').strip 
                end
            }
          }
          Record::Contact.new(r)
        end

      end

    end
  end
end
