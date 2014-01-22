#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'ipaddr'
require 'json'
require 'whois/server/adapters/base'


module Whois

  # The {Whois::Server} class has two important roles:
  #
  # 1. it acts as a database for the WHOIS server definitions
  # 2. it is responsible for selecting the right adapter used to handle the query to the WHOIS server(s).
  #
  class Server

    # The {Whois::Server::Adapters} module is a namespace for all
    # WHOIS server adapters. Each adapter is a subclass of {Whois::Server::Adapters::Base},
    # customized to handle WHOIS queries for a type or a group of servers.
    module Adapters
      autoload :Base,             "whois/server/adapters/base"
      autoload :Arin,             "whois/server/adapters/arin"
      autoload :Arpa,             "whois/server/adapters/arpa"
      autoload :Afilias,          "whois/server/adapters/afilias"
      autoload :Formatted,        "whois/server/adapters/formatted"
      autoload :None,             "whois/server/adapters/none"
      autoload :NotImplemented,   "whois/server/adapters/not_implemented"
      autoload :Standard,         "whois/server/adapters/standard"
      autoload :Verisign,         "whois/server/adapters/verisign"
      autoload :Web,              "whois/server/adapters/web"
    end


    # The WHOIS server definitions.
    #
    # @return [{ Symbol => Array }] The definition Hash.
    # @private
    @@definitions = {}

    # Searches the +/definitions+ folder for definition files and loads them.
    # This method is automatically invoked when this file is parsed
    # by the Ruby interpreter (scroll down to the bottom of this file).
    #
    # @return [void]
    def self.load_definitions
      Dir[File.expand_path("../../../data/*.json", __FILE__)].each { |f| load_json(f) }
    end

    # Loads the definitions from a JSON file.
    #
    # @param  [String] file The path to the definition file.
    #
    # @return [void]
    def self.load_json(file)
      type = File.basename(file, File.extname(file)).to_sym
      JSON.load(File.read(file)).each do |allocation, settings|
        define(type, allocation, settings.delete("host"), Hash[settings.map { |k,v| [k.to_sym, v] }])
      end
    end


    # Lookup and returns the definition list for given <tt>type</tt>,
    # or all definitions if <tt>type</tt> is <tt>nil</tt>.
    #
    # @param  [Symbol] type The type of WHOIS server to lookup.
    #         Known values are :tld, :ipv4, :ipv6.
    #
    # @return [{ Symbol => Array }]
    #         The definition Hash if +type+ is +nil+.
    # @return [Array<Hash>]
    #         The definitions for given +type+ if +type+ is not +nil+ and +type+ exists.
    # @return [nil]
    #         The definitions for given +type+ if +type+ is not +nil+ and +type+ doesn't exist.
    #
    # @example Return the definition database.
    #
    #   Whois::Server.definitions
    #   # => { :tld => [...], :ipv4 => [], ... }
    #
    # @example Return the definitions for given key.
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
    # @param  [Symbol] type
    #         The type of WHOIS server to define.
    #         Known values are :tld, :ipv4, :ipv6.
    # @param  [String] allocation
    #         The allocation, range or hostname, this server is responsible for.
    # @param  [String, nil] host
    #         The server hostname. Use nil if unknown or not available.
    # @param  [Hash] options Optional definition properties.
    # @option options [Class] :adapter (Whois::Server::Adapters::Standard)
    #         This option has a special meaning and determines the adapter Class to use.
    #         Defaults to {Whois::Server::Adapters::Standard} unless specified.
    #         All the other options are passed directly to the adapter which can decide how to use them.
    #
    # @return [void]
    #
    # @example
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
    #   Whois::Server.define :tld, ".test", nil,
    #     :adapter => Whois::Server::Adapter::None
    #
    #   # Define a new server with a custom adapter and options
    #   Whois::Server.define :tld, ".ar", nil,
    #     :adapter => Whois::Server::Adapters::Web,
    #     :url => "http://www.nic.ar/"
    #
    def self.define(type, allocation, host, options = {})
      @@definitions[type] ||= []
      @@definitions[type] <<  [allocation, host, options]
    end

    # Creates a new server adapter from given arguments
    # and returns the server instance.
    #
    # By default, returns a new {Whois::Server::Adapters::Standard} instance.
    # You can customize the behavior passing a custom adapter class
    # as <tt>:adapter</tt> option.
    #
    #   Whois::Server.factory :tld, ".it", "whois.nic.it"
    #   # => #<Whois::Servers::Adapter::Standard>
    #
    #   Whois::Server.factory :tld, ".it", "whois.nic.it",
    #     :option => Whois::Servers::Adapter::Custom
    #   # => #<Whois::Servers::Adapter::Custom>
    #
    # Please note that any adapter is responsible for a limited set
    # of queries, which should be included in the range of the <tt>allocation</tt> parameter.
    # Use {Whois::Server.guess} if you are not sure which adapter
    # is the right one for a specific string.
    #
    # @param  [Symbol] type
    #         The type of WHOIS server to define.
    #         Known values are :tld, :ipv4, :ipv6.
    # @param  [String] allocation
    #         The allocation, range or hostname, this server is responsible for.
    # @param  [String, nil] host
    #         The server hostname. Use nil if unknown or not available.
    # @param  [Hash] options Optional definition properties.
    # @option options [Class] :adapter (Whois::Server::Adapters::Standard)
    #         This option has a special meaning and determines the adapter Class to use.
    #         Defaults to {Whois::Server::Adapters::Standard} unless specified.
    #         All the other options are passed directly to the adapter which can decide how to use them.
    #
    # @return [Whois::Server::Adapters::Standard]
    #         An adapter that can be used to perform queries.
    #
    def self.factory(type, allocation, host, options = {})
      options = options.dup
      adapter = options.delete(:adapter) || Adapters::Standard
      adapter = Adapters.const_get(camelize(adapter)) unless adapter.respond_to?(:new)
      adapter.new(type, allocation, host, options)
    end


    # Parses <tt>string</tt> and tries to guess the right server.
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
    # {Whois::ServerNotSupported} exception.
    #
    #   Whois::Server.guess "mail@example.com"
    #
    #
    # @param  [String] string
    # @return [Whois::Server::Adapters::Base]
    #         The adapter that can be used to perform
    #         WHOIS queries for <tt>string</tt>.
    #
    # @raise  [Whois::ServerNotFound]
    #         When unable to find an appropriate WHOIS adapter
    #         for <tt>string</tt>. Most of the cases, the <tt>string</tt>
    #         haven't been recognised as one of the supported query types.
    # @raise  [Whois::ServerNotSupported]
    #         When the <tt>string</tt> type is detected,
    #         but the object type doesn't have any supported WHOIS adapter associated.
    #
    def self.guess(string)
      # Top Level Domain match
      if matches_tld?(string)
        return factory(:tld, ".", "whois.iana.org")
      end

      # IP address (secure match)
      if matches_ip?(string)
        return find_for_ip(string)
      end

      # Email Address (secure match)
      if matches_email?(string)
        return find_for_email(string)
      end

      # Domain Name match
      if server = find_for_domain(string)
        return server
      end

      # ASN match
      if matches_asn?(string)
        return find_for_asn(string)
      end

      # Game Over
      raise ServerNotFound, "Unable to find a WHOIS server for `#{string}'"
    end


  private

    def self.camelize(string)
      string.to_s.split("_").collect(&:capitalize).join
    end


    def self.matches_tld?(string)
      string =~ /^\.(xn--)?[a-z0-9]+$/
    end

    def self.matches_ip?(string)
      valid_ipv4?(string) || valid_ipv6?(string)
    end

    def self.matches_email?(string)
      string =~ /@/
    end

    def self.matches_asn?(string)
      string =~ /^as\d+$/i
    end

    def self.find_for_ip(string)
      begin
        ip = IPAddr.new(string)
        type = ip.ipv4? ? :ipv4 : :ipv6
        definitions(type).each do |definition|
          if IPAddr.new(definition.first).include?(ip)
            return factory(type, *definition)
          end
        end
      rescue ArgumentError
        # continue
      end
      raise AllocationUnknown, "IP Allocation for `#{string}' unknown. Server definitions might be outdated."
    end

    def self.find_for_email(string)
      raise ServerNotSupported, "No WHOIS server is known for email objects"
    end

    def self.find_for_domain(string)
      definitions(:tld).each do |definition|
        return factory(:tld, *definition) if /#{Regexp.escape(definition.first)}$/ =~ string
      end
      nil
    end

    def self.find_for_asn(string)
      asn = string[/\d+/].to_i
      asn_type = asn <= 65535 ? :asn16 : :asn32
      definitions(asn_type).each do |definition|
        if (range = definition.first.split.map(&:to_i)) && asn >= range.first && asn <= range.last
          return factory(asn_type, *definition)
        end
      end
      raise AllocationUnknown, "Unknown AS number - `#{asn}'."
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
