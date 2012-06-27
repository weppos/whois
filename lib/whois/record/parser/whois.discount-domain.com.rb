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

      # @see Whois::Record::Parser::Example
      #   The Example parser for the list of all available methods.
      #
      # @since 2.4.0 
      class WhoisDiscountDomainCom < Base 
          @@addr_regex = { 
              "Organization:" => :organization, 
              "Name:" => :name, 
              "Street1:" => :street1, 
              "Street2:" => :street2, 
              "City:" => :city, 
              "State:" => :state, 
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
          if content_for_scanner =~ /Last Updated on: (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :expires_on do
          if content_for_scanner =~ /Expiration Date: (.+?)\n/
            Time.parse($1)
          end
        end

        property_supported :registrar do
          Record::Registrar.new(
            :name => "GMO INTERNET, INC. DBA ONAMAE.COM",
            :organization => "GMO INTERNET, INC. DBA ONAMAE.COM",
            :url  => "http://www.onamae.com"
          )
        end

        property_supported :registrant_contacts do
          build_contact(/^\s*Registrant Name:.+(?=^\s*Admin Name)/m, Record::Contact::TYPE_REGISTRANT)
        end

        property_supported :admin_contacts do
          build_contact(/^\s*Admin Name:.+(?=^\s*Billing Name)/m, Record::Contact::TYPE_ADMIN)
        end

        property_supported :technical_contacts do
          build_contact(/^\s*Tech Name:.+(?=^\s*Name Server)/m, Record::Contact::TYPE_TECHNICAL)
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
        #Registrant Organization: STUFF
        #Registrant Street1: STUFF
        #Registrant Street2: STUFF
        #Registrant City: STUFF
        #Registrant State: STUFF
        #Registrant Postal Code: STUFF
        #Registrant Country: STUFF
        #Registrant Phone: STUFF
        #Registrant Fax: STUFF
        #Registrant Email: STUFF
        #Admin Name: STUFF
        #Admin Organization: STUFF
        #Admin Street1: STUFF
        #Admin Street2: STUFF
        #Admin City: STUFF
        #Admin State: STUFF
        #Admin Postal Code: STUFF
        #Admin Country: STUFF
        #Admin Phone: STUFF
        #Admin Fax: STUFF
        #Admin Email: STUFF
        #Billing Name: STUFF
        #Billing Organization: STUFF
        #Billing Street1: STUFF
        #Billing Street2: STUFF
        #Billing City: STUFF
        #Billing State: STUFF
        #Billing Postal Code: STUFF
        #Billing Country: STUFF
        #Billing Phone: STUFF
        #Billing Fax: STUFF
        #Billing Email: STUFF
        #Tech Name: STUFF
        #Tech Organization: STUFF
        #Tech Street1: STUFF
        #Tech Street2: STUFF
        #Tech City: STUFF
        #Tech State: STUFF
        #Tech Postal Code: STUFF
        #Tech Country: STUFF
        #Tech Phone: STUFF
        #Tech Fax: STUFF
        #Tech Email: STUFF
        #Name Server: STUFF
        #Name Server: STUFF

        def build_contact(element, type)

         # Record::Contact.new(
         #   :type         => type,
         #   :name         => "dummy",
         #   :organization => "organization",
         #   :address      => "address",
         #   :city         => "city",
         #   :state        => "state",
         #   :zip          => "zip",
         #   :country_code => "US",
         #   :email        => "email@dd.com",
         #   :phone        => "1222",
         #   :fax          => nil
         # )
         #
          match =  content_for_scanner.slice(element)
          return unless match
          pattern = /^.+:\s*/
          contents = match.split("\n").map(&:strip)
          lines = contents[0..-1]
          return if lines.nil? or lines.length == 0 
          r = {:type => type}
          lines.each { |line|
            @@addr_regex.each_pair { |re, k|
                if Regexp.new(re).match(line)
                  r[k] = line.gsub(pattern, '').strip 
                end
            }
          }
          r[:address] = "#{r[:street1]} #{r[:street2]}"
          r.delete(:street1)
          r.delete(:street2)
          Record::Contact.new(r)
        end

      end

    end
  end
end





