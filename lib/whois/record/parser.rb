#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


module Whois
  class Record

    # The parsing controller that stays behind the {Whois::Record}.
    #
    # It provides object-oriented access to a WHOIS response.
    # The list of properties and methods is available
    # in the following constants:
    #
    # * {Whois::Record::Parser::METHODS}
    # * {Whois::Record::Parser::PROPERTIES}
    #
    class Parser

      METHODS = [
        :contacts,
        :changed?, :unchanged?,
        # :response_incomplete?, :response_throttled?, :response_unavailable?,
        # :referral_whois, :referral_url,
      ]

      PROPERTIES = [
        :disclaimer,
        :domain, :domain_id,
        :status, :available?, :registered?,
        :created_on, :updated_on, :expires_on,
        :registrar,
        :registrant_contacts, :admin_contacts, :technical_contacts,
        :nameservers,
      ]

      PROPERTY_STATE_NOT_IMPLEMENTED = :not_implemented
      PROPERTY_STATE_NOT_SUPPORTED = :not_supported
      PROPERTY_STATE_SUPPORTED = :supported


      # Returns the proper parser instance for given <tt>part</tt>.
      # The parser class is selected according to the
      # value of the <tt>#host</tt> attribute for given <tt>part</tt>.
      #
      # @param  [Whois::Record::Part] part The part to get the parser for.
      #
      # @return [Whois::Record::Parser::Base]
      #         An instance of the specific parser for given part.
      #         The instance is expected to be a child of {Whois::Record::Parser::Base}.
      #
      # @example
      #
      #   # Parser for a known host
      #   Parser.parser_for("whois.example.com")
      #   # => #<Whois::Record::Parser::WhoisExampleCom>
      #
      #   # Parser for an unknown host
      #   Parser.parser_for("missing.example.com")
      #   # => #<Whois::Record::Parser::Blank>
      #
      def self.parser_for(part)
        parser_klass(part.host).new(part)
      rescue LoadError
        Parser.const_defined?("Blank") || autoload("blank")
        Parser::Blank.new(part)
      end

      # Detects the proper parser class according to given <tt>host</tt>
      # and returns the class constant.
      #
      # This method autoloads missing parser classes. If you want to define
      # a custom parser, simple make sure the class is loaded in the Ruby
      # environment before this method is called.
      #
      # @param  [String] host The server host.
      #
      # @return [Class] The instance of Class representing the parser Class
      #         corresponding to <tt>host</tt>. If <tt>host</tt> doesn't have
      #         a specific parser implementation, then returns
      #         the {Whois::Record::Parser::Blank} {Class}.
      #         The {Class} is expected to be a child of {Whois::Record::Parser::Base}.
      # @raises LoadError If the class is not found.
      #
      # @example
      #
      #   Parser.parser_klass("whois.example.com")
      #   # => Whois::Record::Parser::WhoisExampleCom
      #
      def self.parser_klass(host)
        name = host_to_parser(host)
        Parser.const_defined?(name) || autoload(host)
        Parser.const_get(name)
      end

      # Converts <tt>host</tt> to the corresponding parser class name.
      #
      # @param  [String] host The server host.
      # @return [String] The class name.
      #
      # @example
      #
      #   Parser.host_to_parser("whois.nic.it")
      #   # => "WhoisNicIt"
      #
      #   Parser.host_to_parser("whois.nic-info.it")
      #   # => "WhoisNicInfoIt"
      #
      def self.host_to_parser(host)
        host.to_s.downcase.
          gsub(/[.-]/, '_').
          gsub(/(?:^|_)(.)/)  { $1.upcase }
      end

      # Requires the file at <tt>whois/record/parser/#{name}</tt>.
      #
      # @param  [String] name The file name to load.
      #
      # @return [void]
      #
      def self.autoload(name)
        require "whois/record/parser/#{name}"
      end


      # @return [Whois::Record] The record referenced by this parser.
      attr_reader :record


      # Initializes and return a new parser from +record+.
      #
      # @param  [Whois::Record] record
      #
      def initialize(record)
        @record = record
      end

      # Checks if this class respond to given method.
      #
      # Overrides the default implementation to add support
      # for {PROPERTIES} and {METHODS}.
      #
      # @return [Boolean]
      def respond_to?(symbol, include_private = false)
        respond_to_parser_method?(symbol) || super
      end


      # Returns an array with all host-specific parsers initialized for the parts
      # contained into this parser.
      # The array is lazy-initialized.
      #
      # @return [Array<Whois::Record::Parser::Base>]
      #
      def parsers
        @parsers ||= init_parsers
      end

      # Checks if the <tt>property</tt> passed as symbol
      # is supported in any of the parsers.
      #
      # @return [Boolean]
      #
      # @see Whois::Record::Parser::Base.property_supported?
      #
      def property_any_supported?(property)
        parsers.any? { |parser| parser.property_supported?(property) }
      end

      # Checks if the <tt>property</tt> passed as symbol
      # is "not implemented" in any of the parsers.
      #
      # @return [Boolean]
      #
      def property_any_not_implemented?(property)
        parsers.any? { |parser| parser.class.property_state?(property, Whois::Record::Parser::PROPERTY_STATE_NOT_IMPLEMENTED) }
      end


      # @!group Methods

      # Collects and returns all the contacts from all the record parts.
      #
      # @return [Array<Whois::Record::Contact>]
      #
      # @see Whois::Record#contacts
      # @see Whois::Record::Parser::Base#contacts
      #
      def contacts
        parsers.map(&:contacts).flatten
      end

      # @!endgroup


      # @!group Response

      # Loop through all the record parts to check
      # if at least one part changed.
      #
      # @param  [Whois::Record::Parser] other The other parser instance to compare.
      # @return [Boolean]
      #
      # @see Whois::Record#changed?
      # @see Whois::Record::Parser::Base#changed?
      #
      def changed?(other)
        !unchanged?(other)
      end

      # The opposite of {#changed?}.
      #
      # @param  [Whois::Record::Parser] other The other parser instance to compare.
      # @return [Boolean]
      #
      # @see Whois::Record#unchanged?
      # @see Whois::Record::Parser::Base#unchanged?
      #
      def unchanged?(other)
        unless other.is_a?(self.class)
          raise(ArgumentError, "Can't compare `#{self.class}' with `#{other.class}'")
        end

        equal?(other) ||
        parsers.size == other.parsers.size && all_in_parallel?(parsers, other.parsers) { |one, two| one.unchanged?(two) }
      end


      # Loop through all the parts to check if at least
      # one part is an incomplete response.
      #
      # @return [Boolean]
      #
      # @see Whois::Record#response_incomplete?
      # @see Whois::Record::Parser::Base#response_incomplete?
      #
      def response_incomplete?
        any_is?(parsers, :response_incomplete?)
      end

      # Loop through all the parts to check if at least
      # one part is a throttle response.
      #
      # @return [Boolean]
      #
      # @see Whois::Record#response_throttled?
      # @see Whois::Record::Parser::Base#response_throttled?
      #
      def response_throttled?
        any_is?(parsers, :response_throttled?)
      end

      # Loop through all the parts to check if at least
      # one part is an unavailable response.
      #
      # @return [Boolean]
      #
      # @see Whois::Record#response_unavailable?
      # @see Whois::Record::Parser::Base#response_unavailable?
      #
      def response_unavailable?
        any_is?(parsers, :response_unavailable?)
      end

      # @!endgroup


      private

      # @api private
      def self.define_property_method(method)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{method}(*args, &block)
            delegate_property_to_parsers(:#{method}, *args, &block)
          end
        RUBY
      end

      # @api private
      def self.define_method_method(method)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{method}(*args, &block)
            delegate_method_to_parsers(:#{method}, *args, &block)
          end
        RUBY
      end

      def respond_to_parser_method?(symbol)
        Parser::PROPERTIES.include?(symbol) || Parser::METHODS.include?(symbol)
      end

      def method_missing(method, *args, &block)
        if PROPERTIES.include?(method)
          self.class.define_property_method(method)
          send(method, *args, &block)
        elsif METHODS.include?(method)
          self.class.define_method_method(method)
          send(method, *args, &block)
        else
          super
        end
      end

      def delegate_property_to_parsers(method, *args, &block)
        if parsers.empty?
          raise ParserError, "Unable to select a parser because the Record is empty"
        elsif (parser = select_parser { |p| p.class.property_state?(method, PROPERTY_STATE_SUPPORTED) })
          parser.send(method, *args, &block)
        elsif (parser = select_parser { |p| p.class.property_state?(method, PROPERTY_STATE_NOT_SUPPORTED) })
          parser.send(method, *args, &block)
        else
          raise AttributeNotImplemented, "Unable to find a parser for property `#{method}'"
        end
      end

      def delegate_method_to_parsers(method, *args, &block)
        if parsers.empty?
          raise ParserError, "Unable to select a parser because the Record is empty"
        elsif (parser = select_parser { |p| p.respond_to?(method) })
          parser.send(method, *args, &block)
        else
          nil
        end
      end

      # Loops through all record parts, for each part
      # tries to guess the appropriate parser object whenever available,
      # and returns the final array of server-specific parsers.
      #
      # Parsers are initialized in reverse order for performance reason.
      #
      # @return [Array<Class>] An array of Class,
      #         where each item is the parts reverse-N specific parser {Class}.
      #         Each {Class} is expected to be a child of {Whois::Record::Parser::Base}.
      #
      # @example
      #
      #   parser.parts
      #   # => [whois.foo.com, whois.bar.com]
      #
      #   parser.parsers
      #   # => [Whois::Record::Parser::WhoisBarCom, Whois::Record::Parser::WhoisFooCom]
      #
      # @api private
      def init_parsers
        record.parts.reverse.map { |part| self.class.parser_for(part) }
      end

      # Selects the first parser in {#parsers} where blocks evaluates to true.
      #
      # @return [Whois::Record::Parser::Base]
      #         The parser for which the block returns true.
      # @return [nil]
      #         If the parser wasn't found.
      #
      # @yield  [parser]
      #
      # @example
      #
      #   select_parser { |parser| parser.class.property_state?(:nameserver, :any) }
      #   # => #<Whois::Record::Parser::WhoisExampleCom>
      #   select_parser { |parser| parser.class.property_state?(:nameservers, PROPERTY_STATE_SUPPORTED) }
      #   # => nil
      #
      # @api private
      def select_parser(&block)
        parsers.each do |parser|
          return parser if block.call(parser)
        end
        nil
      end

      # @api private
      def all_in_parallel?(*args)
        count = args.first.size
        index = 0

        while index < count
          return false unless yield(*args.map { |arg| arg[index] })
          index += 1
        end
        true
      end

      # @api private
      def any_is?(collection, symbol)
        collection.any? { |item| item.is(symbol) }
      end

    end

  end
end
