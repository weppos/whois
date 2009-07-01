#
# = Ruby Whois
#
# A pure Ruby WHOIS client.
#
#
# Category::    Net
# Package::     WWW::Delicious
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


require 'yaml'


module Whois
  
  class Server
    
    # Parses an user-supplied string and tries to guess the right server.
    def self.whichwhois(string)
      # TODO: IPv6 address
      # TODO: RPSL hierarchical objects
      
      # Email Address
      if string =~ /@/
        find_for_email(string)
      end
      
      # TODO: NSI NIC
      # TODO: ASN32
      # TODO: IP
      
      # Domain
      find_for_domain(string)
      
      # TODO: guessing
      # TODO: game-over
    end
    
    
    def self.find_for_email(string)
      raise ServerNotSupported, "No whois server is known for email objects"
    end
    
    def self.find_for_domain(string)
      servers.each do |ext, server|
        return server if string.slice(-ext.size, ext.size) == ext
      end
      # you might want to remove this raise statement
      # to make the guessing more clever.
      raise ServerNotFound, "Unable to find a WHOIS server for `#{string}'"
    end
    
    def self.servers
      @@servers ||= YAML.load_file(File.dirname(__FILE__) + "/servers.yml")
    end
    
    
  end
  
end