#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


module Whois
  class Record

    # The parsing controller that stays behind the {Whois::Record}.
    #
    # It provides object-oriented access to a WHOIS response.
    # The list of properties and methods is available
    # in the following constants:
    #
    # * {Whois::Record::METHODS}
    # * {Whois::Record::PROPERTIES}
    #
    class Parser

      METHODS = [
        :changed?, :unchanged?,
        :contacts,
        # :response_throttled?, :response_incomplete?,
      ]

      PROPERTIES = [
        :disclaimer,
        :domain, :domain_id,
        :referral_whois, :referral_url,
        :status, :available?, :registered?,
        :created_on, :updated_on, :expires_on,
        :registrar,
        :registrant_contacts, :admin_contacts, :technical_contacts,
        :nameservers,
      ]


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
      #
      # @example
      #
      #   Parser.parser_klass("missing.example.com")
      #   # => Whois::Record::Parser::Blank
      #
      #   # Define a custom parser for missing.example.com
      #   class Whois::Record::Parser::MissingExampleCom
      #   end
      #
      #   Parser.parser_klass("missing.example.com")
      #   # => Whois::Record::Parser::MissingExampleCom
      #
      def self.parser_klass(host)
        name = host_to_parser(host)
        Parser.const_defined?(name) || autoload(host)
        Parser.const_get(name)

      rescue LoadError
        Parser.const_defined?("Blank") || autoload("blank")
        Parser::Blank
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
        super || PROPERTIES.include?(symbol) || METHODS.include?(symbol)
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

      # Returns <tt>true</tt> if the <tt>property</tt> passed as symbol
      # is supported by any available parser.
      #
      # @return [Boolean]
      #
      # @see Whois::Record::Parser::Base.property_supported?
      #
      def property_supported?(property)
        parsers.any? { |parser| parser.property_supported?(property) }
      end


      # @group Methods

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

      # @endgroup


      # @group Response

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

      # @endgroup


    private

      # @api private
      def self.define_missing_method(method)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{method}(*args, &block)
            delegate_to_parsers(:#{method}, *args, &block)
          end
        RUBY
      end

      def method_missing(method, *args, &block)
        if PROPERTIES.include?(method)
          self.class.define_missing_method(method)
          send(method, *args, &block)
        elsif METHODS.include?(method)
          self.class.define_missing_method(method)
          send(method, *args, &block)
        else
          super
        end
      end

      def delegate_to_parsers(method, *args, &block)
        # Raise an error without any parser
        if parsers.empty?
          raise ParserError, "Unable to select a parser because the record is empty"

        # Select a parser where the property is supported
        # and call the method.
        elsif parser = select_parser(method, :supported)
          parser.send(method, *args, &block)

        # Select a parser where the property is defined but not supported
        # and call the method.
        # The call is expected to raise an exception.
        elsif parser = select_parser(method, :not_supported)
          parser.send(method, *args, &block)

        # The property is not supported nor defined.
        else
          raise PropertyNotAvailable, "Unable to find a parser for `#{method}'"
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
      # @see Whois::Record::Parser#select_parser
      #
      def init_parsers
        record.parts.reverse.map { |part| self.class.parser_for(part) }
      end

      # Selects the first parser in {#parsers}
      # where given property matches <tt>status</tt>.
      #
      # @param  [Symbol] property The property to search for.
      # @param  [Symbol] status The status value.
      #
      # @return [Whois::Record::Parser::Base]
      #         The parser which satisfies given requirement.
      # @return [nil]
      #         If the parser wasn't found.
      #
      # @example
      #
      #   select_parser(:nameservers)
      #   # => #<Whois::Record::Parser::WhoisExampleCom>
      #
      #   select_parser(:nameservers, :supported)
      #   # => nil
      #
      def select_parser(property, status = :any)
        parsers.each do |parser|
          return parser if parser.class.property_registered?(property, status)
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
