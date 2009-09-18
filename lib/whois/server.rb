#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client.
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


require 'ipaddr'
require 'whois/server/adapters/base'
require 'whois/server/adapters/afilias'
require 'whois/server/adapters/arpa'
require 'whois/server/adapters/formatted'
require 'whois/server/adapters/none'
require 'whois/server/adapters/not_implemented'
require 'whois/server/adapters/pir'
require 'whois/server/adapters/standard'
require 'whois/server/adapters/verisign'
require 'whois/server/adapters/web'


module Whois
  
  class Server
    
    @@definitions = {}

    # Searches the /definitions folder for definition files and loads them.
    # This method is automatically invoked when this file is parsed by the Ruby interpreter
    # (scroll down to the bottom of this file).
    def self.load_definitions
      Dir[File.dirname(__FILE__) + '/definitions/*.rb'].each { |file| load(file) }
    end

    # Returns the active definition list.
    # If <tt>type</tt>, returns only the definitions matching given type or
    # nil if no definition exists.
    #
    #   Whois::Server.definitions
    #   # => { :tld => [...], :ipv4 => [], ... }
    #   Whois::Server.definitions(:tld)
    #   # => [...]
    #   Whois::Server.definitions(:invalid)
    #   # => nil
    #
    def self.definitions(type = nil)
      if type.nil?
        @@definitions
      else
        @@definitions[type]
      end
    end

    # Defines a new server for <tt>:type</tt> queries.
    #
    # == Parameters
    #
    # type::
    #   The type of whois server to define. 
    #   Allowed values are :tld, :ipv4, :ipv6.
    # allocation::
    #   The allocation, range or hostname this server is responsible for.
    # host::
    #   The server hostname.
    # options::
    #   Additional options to customize Adpter behavior.
    #
    # ==== Examples
    #
    #   # Define a server for the .it extension
    #   Whois::Server.define :tld, ".it", "whois.nic.it"
    #   # Define a new server for an range of IPv4 addresses
    #   Whois::Server.define :ipv4, "61.192.0.0/12", "whois.nic.ad.jp"
    #   # Define a new server for an range of IPv6 addresses
    #   Whois::Server.define :ipv6, "2001:2000::/19", "whois.ripe.net"
    #
    def self.define(type, allocation, host, options = {})
      @@definitions[type] ||= []
      @@definitions[type] <<  [allocation, host, options]
    end

    # Creates a new server adapter from given arguments
    # and returns the server instance.
    #
    # By default returns a new Whois::Servers::Adapter::Standard instance.
    # You can customize the behavior passing a custom adapter class as :adapter option.
    #
    #   Whois::Server.factory :tld, ".it", "whois.nic.it"
    #   # => #<Whois::Servers::Adapter::Standard>
    #   Whois::Server.factory :tld, ".it", "whois.nic.it", :option => Whois::Servers::Adapter::Custom
    #   # => #<Whois::Servers::Adapter::Custom>
    #
    def self.factory(type, allocation, host, options = {})
      options = options.dup
      (options.delete(:adapter) || Adapters::Standard).new(type, allocation, host, options)
    end
    
    
    # Parses <tt>qstring</tt> and tries to guess the right server.
    #
    # It successfully detects the following query types:
    # * ipv6
    # * ipv4
    # * top level domains
    # * emails
    #
    # ==== Raises
    #
    # ServerNotFound::
    #   When unable to find an appropriate whois server for <tt>qstring</tt>.
    #
    def self.guess(qstring)
      # IPv6 address (secure match)
      if valid_ipv6?(qstring)
        return find_for_ipv6(qstring)
      end

      # IPv4 address (secure match)
      if valid_ipv4?(qstring)
        return find_for_ipv4(qstring)
      end

      # Email Address (secure match)
      if qstring =~ /@/
        return find_for_email(qstring)
      end
      
      # TLD
      if server = find_for_tld(qstring)
        return server
      end

      # Gave Over
      raise ServerNotFound, "Unable to find a whois server for `#{qstring}'"
    end
    

    private

      def self.find_for_ipv6(qstring)
        ip = IPAddr.new(qstring)
        definitions(:ipv6).each do |definition|
          if IPAddr.new(definition.first).include?(ip)
            return factory(:ipv6, *definition)
          end
        end
        raise AllocationUnknown,
                "IP Allocation for `#{qstring}' unknown." +
                "Server definitions might be outdated."
      end

      def self.find_for_ipv4(qstring)
        ip = IPAddr.new(qstring)
        definitions(:ipv4).each do |definition|
          if IPAddr.new(definition.first).include?(ip)
            return factory(:ipv4, *definition)
          end
        end
        raise AllocationUnknown,
                "IP Allocation for `#{qstring}' unknown." +
                "Server definitions might be outdated."
      end

      def self.find_for_email(qstring)
        raise ServerNotSupported, "No whois server is known for email objects"
      end

      def self.find_for_tld(qstring)
        definitions(:tld).each do |definition|
          return factory(:tld, *definition) if /#{Regexp.escape(definition.first)}$/ =~ qstring
        end
        nil
      end

      def self.valid_ipv4?(addr)
        if /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/ =~ addr
          return $~.captures.all? {|i| i.to_i < 256}
        end
        false
      end

      def self.valid_ipv6?(addr)
        # IPv6 (normal)
        return true if /\A[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*\Z/ =~ addr
        return true if /\A[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*)?\Z/ =~ addr
        return true if /\A::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*)?\Z/ =~ addr
        # IPv6 (IPv4 compat)
        return true if /\A[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*:/ =~ addr && valid_ipv4?($')
        return true if /\A[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*:)?/ =~ addr && valid_ipv4?($')
        return true if /\A::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*:)?/ =~ addr && valid_ipv4?($')
        false
      end

    end

end

Whois::Server.load_definitions