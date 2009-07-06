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
        break(srv) if /#{ext}$/ =~ string
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
        query_crsnic(string)
      elsif server == "PIR"
        query_pir(string)
      elsif server == "AFILIAS"
        query_afilias(string)
      elsif server == "NICCC"
        query_niccc(string)
      elsif server == "ARPA"
        whichwhois(inaddr_to_ip(string))
      else
        server
      end
    end
    
    def self.servers
      @@servers ||= YAML.load_file(File.dirname(__FILE__) + "/servers.yml")
    end
    
    private
      
      def self.ask_the_socket(query, server, port = 43)
        client = TCPSocket.open(server, port)
        client.write("#{query}\r\n")
        client.read
      ensure
        client.close if client
      end
      
      
      # FIXME: incomplete query handler
      # 1. if not found, the query returns the response
      # 2. if found, the query could return the response
      # 3. if found, the query could return a referral
      def self.query_crsnic(query)
        response = ask_the_socket("=#{query}", "whois.crsnic.net")
        if response =~ /Domain Name:/ && response =~ /Whois Server: (\S+)/
          return $1
        else
          # FIXME: Here's the full response. ARGH!
        end
      end
      
      # FIXME: incomplete query handler
      # It behavies like query_crsnic because the whois belongs to verisign.
      def self.query_niccc(query)
        response = ask_the_socket("=#{query}", "whois.nic.cc")
        if response =~ /Domain Name:/ && response =~ /Whois Server: (\S+)/
          return $1
        else
          # FIXME: Here's the full response. ARGH!
        end
      end
      
      # FIXME: incomplete query handler
      # 1. if not found, the query returns the response
      # 2. if found, the query could return the response (95% probs)
      # 3. if found, the query could return a referral
      def self.query_pir(query)
        response = ask_the_socket("FULL #{query}", "whois.publicinterestregistry.net")
        if response =~ /Registrant Name:SEE SPONSORING REGISTRAR/ && 
           response =~ /Registrant Street1:Whois Server:(\S+)/
          return $1
        else
          # FIXME: Here's the full response. ARGH!
          # Usually this happens for the 95% of queries. Isn't that wonderful?
        end
      end
      
      # FIXME: incomplete query handler
      # 1. if not found, the query returns the response
      # 2. if found, the query could return the response
      # 3. if found, the query could return a referral
      def self.query_afilias(query)
        response = ask_the_socket(query, "whois.afilias-grs.info")
        # TEST: ensure regexp matches
        if response =~ /Domain Name:/ &&  response =~ /Whois Server:(\S+)/
          return $1
        else
          # FIXME: Here's the full response. ARGH!
        end
      end
      
      # "127.1.168.192.in-addr.arpa" => "192.168.1.127"
      # "1.168.192.in-addr.arpa" => "192.168.1.0"
      # "168.192.in-addr.arpa" => "192.168.0.0"
      # "192.in-addr.arpa" => "192.0.0.0"
      # "in-addr.arpa" => "0.0.0.0"
      def self.inaddr_to_ip(query)
        unless /^([0-9]{1,3}\.?){0,4}in-addr\.arpa$/ =~ query
          raise ServerError, "Invalid .in-addr.arpa address"
        end
         a, b, c, d = query.scan(/[0-9]{1,3}\./).reverse
        [a, b, c, d].map do |token|
          token = (token ||= 0).to_i
          if token <= 255 && token >= 0
            token
          else
            raise ServerError, "Invalid .in-addr.arpa token `#{token}'"
          end
        end.join(".")
      end
    
  end
  
end