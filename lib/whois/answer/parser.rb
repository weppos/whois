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


module Whois
  class Answer

    # The parsing controller that stays behind the {Whois::Answer}.
    #
    # It provides object-oriented access to a WHOIS response.
    # The list of properties and methods is available
    # in the following constants:
    #
    # * {Whois::Answer::METHODS}
    # * {Whois::Answer::PROPERTIES}
    #
    class Parser

      METHODS = [
        :changed?, :unchanged?,
        :contacts,
        # :throttled?, :incomplete?,
      ]

      PROPERTIES = [
        :disclaimer,
        :domain, :domain_id,
        :referral_whois, :referral_url,
        :status, :available?, :registered?,
        :created_on, :updated_on, :expires_on,
        :registrar,
        :registrant_contact, :admin_contact, :technical_contact,
        :nameservers,
      ]


      # Returns the proper parser instance for given <tt>part</tt>.
      # The parser class is selected according to the
      # value of the <tt>#host</tt> attribute for given <tt>part</tt>.
      #
      # @param  [Whois::Answer::Part] part The part to get the parser for.
      #
      # @return [Whois::Answer::Parser::Base]
      #         An instance of the specific parser for given part.
      #         The instance is expected to be a child of {Whois::Answer::Parser::Base}.
      #
      # @example
      #
      #   # Parser for a known host
      #   Parser.parser_for("whois.example.com")
      #   # => #<Whois::Answer::Parser::WhoisExampleCom>
      #
      #   # Parser for an unknown host
      #   Parser.parser_for("missing.example.com")
      #   # => #<Whois::Answer::Parser::Blank>
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
      #         the {Whois::Answer::Parser::Blank} {Class}.
      #         The {Class} is expected to be a child of {Whois::Answer::Parser::Base}.
      #
      # @example
      #
      #   Parser.parser_klass("missing.example.com")
      #   # => Whois::Answer::Parser::Blank
      #
      #   # Define a custom parser for missing.example.com
      #   class Whois::Answer::Parser::MissingExampleCom
      #   end
      #
      #   Parser.parser_klass("missing.example.com")
      #   # => Whois::Answer::Parser::MissingExampleCom
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
        host.to_s.
          gsub(/[.-]/, '_').
          gsub(/(?:^|_)(.)/)  { $1.upcase }
      end

      # Requires the file at <tt>whois/answer/parser/#{name}</tt>.
      #
      # @param  [String] name The file name to load.
      #
      # @return [void]
      #
      def self.autoload(name)
        require "whois/answer/parser/#{name}"
      end


      # @return [Whois::Answer] The answer referenced by this parser.
      attr_reader :answer


      # Initializes and return a new parser from +answer+.
      #
      # @param  [Whois::Answer]
      #
      def initialize(answer)
        @answer = answer
      end

      # Checks if this class respond to given method.
      #
      # Overrides the default implementation to add support
      # for {PROPERTIES} and {METHODS}.
      #
      # @returns [Boolean]
      def respond_to?(symbol, include_private = false)
        super || PROPERTIES.include?(symbol) || METHODS.include?(symbol)
      end


      # Returns an array with all host-specific parsers initialized for the parts
      # contained into this parser.
      # The array is lazy-initialized.
      #
      # @return [Array<Whois::Answer::Parser::Base>]
      #
      def parsers
        @parsers ||= init_parsers
      end

      # Returns <tt>true</tt> if the <tt>property</tt> passed as symbol
      # is supported by any available parser.
      #
      # @return [Boolean]
      #
      # @see Whois::Answer::Parser::Base.property_supported?
      #
      def property_supported?(property)
        parsers.any? { |parser| parser.property_supported?(property) }
      end


      # @group Methods

      # Collects and returns all the contacts from all the answer parts.
      #
      # @return [Array<Whois::Answer::Contact>]
      #
      # @see Whois::Answer#contacts
      # @see Whois::Answer::Parser::Base#contacts
      #
      def contacts
        parsers.inject([]) { |all, parser| all.concat(parser.contacts) }
      end

      # @endgroup


      # @group Response

      # Loop through all the answer parts to check if at least
      # one part changed.
      #
      # @param  [Whois::Answer::Parser] other The other parser instance to compare.
      # @return [Boolean]
      #
      # @see Whois::Answer#changed?
      # @see Whois::Answer::Parser::Base#changed?
      #
      def changed?(other)
        !unchanged?(other)
      end

      # The opposite of {#changed?}.
      #
      # @param  [Whois::Answer::Parser] other The other parser instance to compare.
      # @return [Boolean]
      #
      # @see Whois::Answer#unchanged?
      # @see Whois::Answer::Parser::Base#unchanged?
      #
      def unchanged?(other)
        unless other.is_a?(self.class)
          raise(ArgumentError, "Can't compare `#{self.class}' with `#{other.class}'")
        end

        equal?(other) ||
        parsers.size == other.parsers.size && all_in_parallel?(parsers, other.parsers) { |one, two| one.unchanged?(two) }
      end

      # Loop through all the parts to check if at least
      # one part is a throttle response.
      #
      # @return [Boolean]
      #
      # @see Whois::Answer#throttled?
      # @see Whois::Answer::Parser::Base#throttled?
      #
      def throttled?
        any_and_respond?(parsers, :throttled?)
      end

      # Loop through all the parts to check if at least
      # one part is an incomplete response.
      #
      # @return [Boolean]
      #
      # @see Whois::Answer#incomplete?
      # @see Whois::Answer::Parser::Base#incomplete?
      #
      def incomplete?
        any_and_respond?(parsers, :incomplete?)
      end

      # @endgroup


      private

        # @api internal
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
            raise ParserError, "Unable to select a parser because the answer is empty"

          # Select a parser where the property is supported
          # and call the method.
          elsif parser = select_parser(method, :supported)
            parser.send(method, *args, &block)

          # Select a parser where the property is defined
          # (but not supported) and call the method.
          # The call is expected to raise an exception.
          elsif parser = select_parser(method)
            parser.send(method, *args, &block)

          # The property is not supported nor defined.
          else
            raise PropertyNotAvailable, "Unable to find a parser for `#{method}'"
          end
        end

        # Loops through all answer parts, for each part
        # tries to guess the appropriate parser object whenever available,
        # and returns the final array of server-specific parsers.
        #
        # Parsers are initialized in reverse order for performance reason.
        #
        # @return [Array<Class>] An array of Class,
        #         where each item is the parts reverse-N specific parser {Class}.
        #         Each {Class} is expected to be a child of {Whois::Answer::Parser::Base}.
        #
        # @example
        #
        #   parser.parts
        #   # => [whois.foo.com, whois.bar.com]
        #
        #   parser.parsers
        #   # => [Whois::Answer::Parser::WhoisBarCom, Whois::Answer::Parser::WhoisFooCom]
        #
        # @see Whois::Answer::Parser#select_parser
        #
        def init_parsers
          answer.parts.reverse.map { |part| self.class.parser_for(part) }
        end

        # Selects the first parser in {#parsers}
        # where given property matches <tt>status</tt>.
        #
        # @param  [Symbol] property The property to search for.
        # @param  [Symbol] status The status value.
        #
        # @return [Whois::Answer::Parser::Base]
        #         The parser which satisfies given requirement.
        # @return [nil]
        #         If the parser wasn't found.
        #
        # @example
        #
        #   select_parser(:nameservers)
        #   # => #<Whois::Answer::Parser::WhoisExampleCom>
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

        # @api internal
        def all_in_parallel?(*args)
          count = args.first.size
          index = 0

          while index < count
            return false unless yield(*args.map { |arg| arg[index] })
            index += 1
          end
          true
        end

        # @api internal
        def any_and_respond?(collection, symbol)
          collection.any? { |item| item.respond_to?(symbol) && item.send(symbol) }
        end

    end

  end
end