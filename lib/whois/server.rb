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

    def self.load_definitions
      Dir[File.dirname(__FILE__) + '/definitions/*.rb'].each { |file| load(file) }
    end

    def self.definitions(type = nil)
      if type.nil?
        @@definitions
      else
        @@definitions[type]
      end
    end
    
    def self.define(type, allocation, server, options = {})
      @@definitions[type] ||= []
      @@definitions[type] <<  [allocation, server, options]
    end

    def self.factory(type, allocation, host, options = {})
      options = options.dup
      (options.delete(:adapter) || Adapters::Standard).new(type, allocation, host, options)
    end
    
    
    # Parses an user-supplied string and tries to guess the right server.
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
        definitions(:ipv6).each do |definition|
          if IPAddr.new(definition.first).include?(qstring)
            return factory(:ipv6, *definition)
          end
        end
        raise AllocationUnknown,
                "IP Allocation for `#{qstring}' unknown." +
                "Server definitions might be outdated."
      end

      def self.find_for_ipv4(qstring)
        definitions(:ipv4).each do |definition|
          if IPAddr.new(definition.first).include?(qstring)
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
          return factory(:tld, *definition) if /#{definition.first}$/ =~ qstring
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
        return true if /\A[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*:/ =~ addr && valid_v4?($')
        return true if /\A[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*:)?/ =~ addr && valid_v4?($')
        return true if /\A::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*:)?/ =~ addr && valid_v4?($')
        false
      end

    end

end

Whois::Server.load_definitions