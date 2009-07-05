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
      server = servers.each do |ext, srv|
        break(srv) if string.slice(-ext.size, ext.size) == ext
      end
      
      if server.nil?
        # you might want to remove this raise statement
        # to make the guessing more clever.
        raise ServerNotFound, "Unable to find a whois server for `#{string}'"
      elsif server =~ /^WEB (.*)/
        raise WebInterfaceError,  "This TLD has no whois server, " +
                                  "but you can access the whois database at `#{$1}'"
      elsif server == "NONE"
        raise NoInterfaceError,   "This TLD has no whois server"
      elsif server == "CRSNIC"
        raise NotImplementedError
      elsif server == "PIR"
        raise NotImplementedError
      elsif server == "AFILIAS"
        raise NotImplementedError
      elsif server == "NICCC"
        raise NotImplementedError
      elsif server == "ARPA"
        raise NotImplementedError
      else
        server
      end
    end
    
    def self.servers
      @@servers ||= YAML.load_file(File.dirname(__FILE__) + "/servers.yml")
    end
    
    
  end
  
end