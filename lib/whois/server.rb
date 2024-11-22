# frozen_string_literal: true

#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2024 Simone Carletti <weppos@weppos.net>
#++


require "ipaddr"
require "json"
require "whois/server/adapters/base"
require "whois/server/adapters/arin"
require "whois/server/adapters/arpa"
require "whois/server/adapters/afilias"
require "whois/server/adapters/formatted"
require "whois/server/adapters/none"
require "whois/server/adapters/not_implemented"
require "whois/server/adapters/standard"
require "whois/server/adapters/verisign"
require "whois/server/adapters/web"


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
    end

    # @return [Array<Symbol>] the definition types
    TYPES = [
      TYPE_TLD = :tld,
      TYPE_IPV4  = :ipv4,
      TYPE_IPV6  = :ipv6,
      TYPE_ASN16 = :asn16,
      TYPE_ASN32 = :asn32,
    ].freeze

    # Empty hash constant used to save allocation for definitions with empty settings.
    EMPTY_HASH = {}.freeze
    private_constant :EMPTY_HASH

    class << self

      # Clears the definition and reset them to an empty list.
      #
      # @return [void]
      def clear_definitions
        @definitions = {}
      end

      # Searches the +/definitions+ folder for definition files and loads them.
      # This method is automatically invoked when this file is parsed
      # by the Ruby interpreter (scroll down to the bottom of this file).
      #
      # @return [void]
      def load_definitions
        clear_definitions
        Dir[File.expand_path("../../data/*.json", __dir__)].each { |f| load_json(f) }
      end

      # Loads the definitions from a JSON file.
      #
      # @param  [String] file The path to the definition file.
      #
      # @return [void]
      def load_json(file)
        type = File.basename(file, File.extname(file)).to_sym
        JSON.parse(File.read(file)).each do |allocation, settings|
          next if allocation == "_"

          settings.reject! { |k, _| k.start_with?("_") }
          host = settings.delete("host")
          host = intern_string(host) if host
          options = if settings.empty?
                      EMPTY_HASH
                    else
                      settings.to_h { |k, v| [k.to_sym, v.is_a?(String) ? intern_string(v) : v] }.freeze
                    end
          define(type, allocation, host, options)
        end
      end


      # Lookup and returns the definition list for given `type`.
      #
      # @param  [Symbol] type The type of WHOIS server to lookup.
      #         See Whois::Server::TYPES for valid types.
      #
      # @return [{ Symbol => Array }]
      #         The definition Hash if +type+ is +nil+.
      # @return [Array<Hash>]
      #         The definitions for given +type+ if +type+ is not +nil+ and +type+ exists.
      #
      # @example Return the definitions for given key.
      #
      #   Whois::Server.definitions(:tld)
      #   # => [...]
      #
      #   Whois::Server.definitions(:invalid)
      #   # => nil
      #
      def definitions(type)
        TYPES.include?(type) or
          raise(ArgumentError, "`#{type}` is not a valid definition type")

        _definitions(type).values
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
      #   Whois::Server.define :tld, "it", "whois.nic.it"
      #
      #   # Define a new server for an range of IPv4 addresses
      #   Whois::Server.define :ipv4, "61.192.0.0/12", "whois.nic.ad.jp"
      #
      #   # Define a new server for an range of IPv6 addresses
      #   Whois::Server.define :ipv6, "2001:2000::/19", "whois.ripe.net"
      #
      #   # Define a new server with a custom adapter
      #   Whois::Server.define :tld, "test", nil,
      #     :adapter => Whois::Server::Adapter::None
      #
      #   # Define a new server with a custom adapter and options
      #   Whois::Server.define :tld, "ar", nil,
      #     :adapter => Whois::Server::Adapters::Web,
      #     :url => "http://www.nic.ar/"
      #
      def define(type, allocation, host, options = EMPTY_HASH)
        TYPES.include?(type) or
          raise(ArgumentError, "`#{type}` is not a valid definition type")

        _definitions(type)[allocation] = [allocation, host, options.freeze]
      end

      # Creates a new server adapter from given arguments
      # and returns the server instance.
      #
      # By default, returns a new {Whois::Server::Adapters::Standard} instance.
      # You can customize the behavior passing a custom adapter class
      # as <tt>:adapter</tt> option.
      #
      #   Whois::Server.factory :tld, "it", "whois.nic.it"
      #   # => #<Whois::Servers::Adapter::Standard>
      #
      #   Whois::Server.factory :tld, "it", "whois.nic.it",
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
      # @return [Whois::Server::Adapters::Base]
      #         a server adapter that can be used to perform queries.
      def factory(type, allocation, host, options = {})
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
      # @param  string [String]
      # @return [Whois::Server::Adapters::Base]
      #         a server adapter that can be used to perform queries.
      #
      # @raise  [Whois::AllocationUnknown]
      #         when the input is an IP, but the IP doesn't have a specific known allocation
      #         that matches one of the existing server definitions.
      # @raise  [Whois::ServerNotFound]
      #         when unable to find an appropriate WHOIS adapter. In most of the cases, the input
      #         is not recognised as one of the supported query types.
      # @raise  [Whois::ServerNotSupported]
      #         when the string type is detected,
      #         but the object type doesn't have any supported WHOIS adapter associated.
      def guess(string)
        # Top Level Domain match
        return factory(:tld, ".", "whois.iana.org") if matches_tld?(string)

        # IP address (secure match)
        return find_for_ip(string) if matches_ip?(string)

        # Email Address (secure match)
        return find_for_email(string) if matches_email?(string)

        # Domain Name match
        if (server = find_for_domain(string))
          return server
        end

        # ASN match
        return find_for_asn(string) if matches_asn?(string)

        # Game Over
        raise ServerNotFound, "Unable to find a WHOIS server for `#{string}'"
      end


      # Searches for definition that matches given IP.
      #
      # @param  string [String]
      # @return [Whois::Server::Adapters::Base, nil]
      #         a server adapter that can be used to perform queries.
      # @raise  [Whois::AllocationUnknown]
      #         when the IP doesn't have a specific known allocation
      #         that matches one of the existing server definitions.
      def find_for_ip(string)
        begin
          ip = IPAddr.new(string)
          type = ip.ipv4? ? TYPE_IPV4 : TYPE_IPV6
          _definitions(type).each_value do |definition|
            return factory(type, *definition) if IPAddr.new(definition.first).include?(ip)
          end
        rescue ArgumentError
          # continue
          nil
        end
        raise AllocationUnknown, "IP Allocation for `#{string}' unknown"
      end

      # Searches for definition that matches given email.
      #
      # @param  string [String]
      # @raise  [Whois::ServerNotSupported]
      #         emails are not supported.
      def find_for_email(_string)
        raise ServerNotSupported, "No WHOIS server is known for email objects"
      end

      # Searches for definition that matches given domain.
      #
      # @param  string [String]
      # @return [Whois::Server::Adapters::Base, nil]
      #         a server adapter that can be used to perform queries.
      def find_for_domain(string)
        token = string
        defs  = _definitions(TYPE_TLD)

        while token != ""
          if (found = defs[token])
            return factory(:tld, *found)
          else
            index = token.index(".")
            break if index.nil?

            token = token[(index + 1)..]
          end
        end

        nil
      end

      # Searches for definition that matches given ASN string.
      #
      # @param  string [String]
      # @return [Whois::Server::Adapters::Base, nil]
      #         a server adapter that can be used to perform queries.
      # @raise  [Whois::AllocationUnknown]
      #         when the IP doesn't have a specific known allocation
      #         that matches one of the existing server definitions.
      def find_for_asn(string)
        asn = string[/\d+/].to_i
        asn_type = asn <= 65_535 ? TYPE_ASN16 : TYPE_ASN32
        _definitions(asn_type).each_value do |definition|
          if (range = definition.first.split.map(&:to_i)) && asn >= range.first && asn <= range.last
            return factory(asn_type, *definition)
          end
        end
        raise AllocationUnknown, "Unknown AS number - `#{asn}'."
      end


      private

      def _definitions(type = nil)
        if type.nil?
          @definitions
        else
          @definitions[type] ||= {}
        end
      end

      if String.method_defined?(:-@)
        def intern_string(string)
          -string
        end
      else
        def intern_string(string)
          string.freeze
        end
      end

      def camelize(string)
        string.to_s.split("_").collect(&:capitalize).join
      end

      def matches_tld?(string)
        string.match?(/^\.(xn--)?[a-z0-9]+$/)
      end

      def matches_ip?(string)
        valid_ipv4?(string) || valid_ipv6?(string)
      end

      def matches_email?(string)
        string.include?("@")
      end

      def matches_asn?(string)
        string.match?(/^as\d+$/i)
      end

      def valid_ipv4?(addr)
        if (m = /\A(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\Z/.match(addr))
          return m.captures.all? { |i| i.to_i < 256 }
        end

        false
      end

      def valid_ipv6?(addr)
        # IPv6 (normal)
        return true if addr.match?(/\A[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*\Z/)
        return true if addr.match?(/\A[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*)?\Z/)
        return true if addr.match?(/\A::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*)?\Z/)
        # IPv6 (IPv4 compat)
        return true if /\A[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*:/ =~ addr && valid_ipv4?(Regexp.last_match.post_match)
        return true if /\A[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*:)?/ =~ addr && valid_ipv4?(Regexp.last_match.post_match)
        return true if /\A::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*:)?/ =~ addr && valid_ipv4?(Regexp.last_match.post_match)

        false
      end

    end
  end

end

Whois::Server.load_definitions
