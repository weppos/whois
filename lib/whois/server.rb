#
# = Ruby Whois
#
# A pure Ruby WHOIS client.
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


require 'whois/server/adapters/base'
require 'whois/server/adapters/standard'
require 'whois/server/adapters/afilias'
require 'whois/server/adapters/arpa'
require 'whois/server/adapters/formatted'
require 'whois/server/adapters/none'
require 'whois/server/adapters/pir'
require 'whois/server/adapters/verisign'
require 'whois/server/adapters/web'


module Whois
  
  class Server
    
    @@definitions = []

    def self.definitions
      @@definitions
    end
    
    def self.define(extension, server, options = {})
      @@definitions << [extension, server, options]
    end

    def self.factory(extension, server, options = {})
      options = options.dup
      (options.delete(:adapter) || Adapters::Standard).new(extension, server, options)
    end
    
    
    # Parses an user-supplied string and tries to guess the right server.
    def self.guess(qstring)
      # TODO: IPv6 address
      
      # Email Address
      if qstring =~ /@/ && server = find_for_email(qstring)
        return server
      end
      
      # TODO: NSI NIC
      # TODO: ASN32
      # TODO: IP
      
      # TLD
      if server = find_for_tld(qstring)
        return server
      end
      
      # TODO: guessing
      # TODO: game-over

      # you might want to remove this raise statement
      # to make the guessing more clever.
      raise ServerNotFound, "Unable to find a whois server for `#{qstring}'"
    end
    

    private

      def self.find_for_email(qstring)
        raise ServerNotSupported, "No whois server is known for email objects"
      end

      def self.find_for_tld(qstring)
        server = definitions.each do |definition|
          return factory(*definition) if /#{definition.first}$/ =~ qstring
        end
      end
    
  end
  
end