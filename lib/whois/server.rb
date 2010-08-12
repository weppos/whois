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


require 'ipaddr'


module Whois

  class Server

    module Adapters
      autoload :Base,             "whois/server/adapters/base"
      autoload :Arpa,             "whois/server/adapters/arpa"
      autoload :Afilias,          "whois/server/adapters/afilias"
      autoload :Formatted,        "whois/server/adapters/formatted"
      autoload :None,             "whois/server/adapters/none"
      autoload :NotImplemented,   "whois/server/adapters/not_implemented"
      autoload :Pir,              "whois/server/adapters/pir"
      autoload :Standard,         "whois/server/adapters/standard"
      autoload :Verisign,         "whois/server/adapters/verisign"
      autoload :Web,              "whois/server/adapters/web"
    end


    @@definitions = {}

    # Searches the /definitions folder for definition files and loads them.
    # This method is automatically invoked when this file is parsed by the Ruby interpreter
    # (scroll down to the bottom of this file).
    def self.load_definitions
      Dir[File.dirname(__FILE__) + '/definitions/*.rb'].each { |file| load(file) }
    end

    # Lookup and returns the definition list for given <tt>type</tt>,
    # or all definitions if <tt>type</tt> is <tt>nil</tt>.
    #
    # ==== Parameters
    #
    # type:: The type of WHOIS server to lookup.
    #   Known values are :tld, :ipv4, :ipv6.
    #
    # ==== Returns
    #
    # Hash:: If the method is called without specifying a <tt>type</tt>.
    # Array:: If the method is called specifying a <tt>type</tt>,
    #   and the <tt>type</tt> exists.
    # nil:: If the method is called specifying a <tt>type</tt>,
    #   and the <tt>type</tt> doesn't exist.
    #
    # ==== Examples
    #
    #   Whois::Server.definitions
    #   # => { :tld => [...], :ipv4 => [], ... }
    #
    #   Whois::Server.definitions(:tld)
    #   # => [...]
    #
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
    # ==== Parameters
    #
    # type:: The type of WHOIS server to define.
    #   Known values are :tld, :ipv4, :ipv6.
    # allocation:: The allocation, range or hostname
    #   this server is responsible for.
    # host:: The server hostname.
    #   Use nil if unknown or not available.
    # options:: Hash of options to customize Adapter behavior.
    #   The <tt>:adapter</tt> option has a special meaning and determines
    #   the adapter Class to use.
    #   Defaults to </tt>Whois::Server::Adapters::Standard</tt> unless specified.
    #   All the other options are passed directly to the adapter which
    #   can decide how to use them.
    #
    # ==== Returns
    #
    # Nothing.
    #
    # ==== Examples
    #
    #   # Define a server for the .it extension
    #   Whois::Server.define :tld, ".it", "whois.nic.it"
    #
    #   # Define a new server for an range of IPv4 addresses
    #   Whois::Server.define :ipv4, "61.192.0.0/12", "whois.nic.ad.jp"
    #
    #   # Define a new server for an range of IPv6 addresses
    #   Whois::Server.define :ipv6, "2001:2000::/19", "whois.ripe.net"
    #
    #   # Define a new server with a custom adapter
    #   Whois::Server.define :tld, ".test", nil, :adapter => Whois::Server::Adapter::None
    #
    #   # Define a new server with a custom adapter and options
    #   Whois::Server.define :tld, ".ar", nil, :adapter => Whois::Server::Adapters::Web, :web => "http://www.nic.ar/"
    #
    def self.define(type, allocation, host, options = {})
      @@definitions[type] ||= []
      @@definitions[type] <<  [allocation, host, options]
    end

    # Creates a new server adapter from given arguments
    # and returns the server instance.
    #
    # By default, returns a new Whois::Servers::Adapter::Standard instance.
    # You can customize the behavior passing a custom adapter class as <tt>:adapter</tt> option.
    #
    #   Whois::Server.factory :tld, ".it", "whois.nic.it"
    #   # => #<Whois::Servers::Adapter::Standard>
    #
    #   Whois::Server.factory :tld, ".it", "whois.nic.it", :option => Whois::Servers::Adapter::Custom
    #   # => #<Whois::Servers::Adapter::Custom>
    #
    # Please note that any adapter is responsible for a limited set of queries,
    # which should be included in the range of the <tt>allocation</tt> parameter.
    # Use <tt>Whois::Server#guess</tt> if you are not sure which adapter is the right one
    # for a specific string.
    #
    # ==== Parameters
    #
    # type:: The type of WHOIS server to create.
    #   Known values are :tld, :ipv4, :ipv6.
    # allocation:: The allocation, range or hostname
    #   this server is responsible for.
    # host:: The server hostname.
    #   Use nil if unknown or not available.
    # options:: Hash of options to customize Adapter behavior.
    #   The <tt>:adapter</tt> option has a special meaning and determines
    #   the adapter Class to use.
    #   Defaults to </tt>Whois::Server::Adapters::Standard</tt> unless specified.
    #   All the other options are passed directly to the adapter which
    #   can decide how to use them.
    #
    # ==== Returns
    #
    # Whois::Server::Adapters::Standard:: An adapter that can be used to perform queries.
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
    # * top level domains (e.g. .com, .net, .it)
    # * domain names (e.g. google.com, google.net, google.it)
    # * emails
    #
    # Note that not all query types actually have a corresponding adapter.
    # For instance, the following request will result in a
    # <tt>Whois::ServerNotSupported</tt> exception.
    #
    #   Whois::Server.guess "mail@example.com"
    #
    # ==== Returns
    #
    # Whois::Server::Adapters::Base:: The adapter that can be used to perform
    #   WHOIS queries for <tt>qstring</tt>.
    #
    # ==== Raises
    #
    # ServerNotFound:: When unable to find an appropriate WHOIS adapter
    #   for <tt>qstring</tt>. Most of the cases, the <tt>qstring</tt>
    #   haven't been recognised as one of the supported query types.
    # ServerNotSupported:: When the <tt>qstring</tt> type is detected,
    #   but the object type doesn't have any supported WHOIS adapter associated.
    #
    def self.guess(qstring)
      # Top Level Domain match
      if matches_tld?(qstring)
        return factory(:tld, ".", "whois.iana.org")
      end
      
      # IP address (secure match)
      if matches_ip?(qstring)
        return find_for_ip(qstring)
      end

      # Email Address (secure match)
      if matches_email?(qstring)
        return find_for_email(qstring)
      end

      # Domain Name match
      if server = find_for_domain(qstring)
        return server
      end

      # Gave Over
      raise ServerNotFound, "Unable to find a whois server for `#{qstring}'"
    end


    private

      def self.matches_tld?(string)
        string =~ /^\.(xn--)?[a-z0-9]+$/
      end

      def self.matches_ip?(string)
        valid_ipv4?(string) || valid_ipv6?(string)
      end

      def self.matches_email?(string)
        string =~ /@/
      end


      def self.find_for_ip(qstring)
        ip = IPAddr.new(qstring)
        type = ip.ipv4? ? :ipv4 : :ipv6
        definitions(type).each do |definition|
          if IPAddr.new(definition.first).include?(ip)
            return factory(type, *definition)
          end
        end
        raise AllocationUnknown, "IP Allocation for `#{qstring}' unknown. Server definitions might be outdated."
      end

      def self.find_for_email(qstring)
        raise ServerNotSupported, "No WHOIS server is known for email objects"
      end

      def self.find_for_domain(qstring)
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
