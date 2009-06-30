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


require 'socket'
require 'timeout'


class Whois

  class Client
    
    class Error < StandardError; end
    class ServerNotFound < Error; end
    
    
    def query(string)
      server = find_server(string)
      ask_the_socket(string, server, 43)
    end
    
    private
      
      def find_server(string)
        self.class.servers.each do |ext, server|
          return server if string.slice(-ext.size, ext.size) == ext
        end
        raise ServerNotFound, "Unable to find a WHOIS server for `#{string}'"
      end
      
      def ask_the_socket(query, server, port = 43)
        client = TCPSocket.open(server, port)
        client.write("#{query}\n")    # I could use put(foo) and forget the \n
        client.read                   # but write/read sounds better than puts/read
      ensure                          # and I really want to use read instead of gets.
        client.close
      end
      
    
    def self.servers
      @@servers ||= YAML.load_file(File.dirname(__FILE__) + "/servers.yml")
    end
    
  end

end