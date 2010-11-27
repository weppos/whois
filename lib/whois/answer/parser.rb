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

    #
    # = Parser
    #
    class Parser

      METHODS = [
        :changed?, :unchanged?,
        :contacts,
        # :throttle?,
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

      attr_reader :answer


      def initialize(answer)
        @answer = answer
      end

      # Returns an array with all host-specific parsers initialized for the parts
      # contained into this parser.
      # The array is lazy-initialized.
      def parsers
        @parsers ||= init_parsers
      end

      # Returns <tt>true</tt> if the <tt>property</tt> passed as symbol
      # is supported by any available parser.
      # See also <tt>Whois::Answer::Parser::Base.supported?</tt>.
      def property_supported?(property)
        parsers.any? { |parser| parser.property_supported?(property) }
      end


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
        parsers.size == other.parsers.size &&
          all_with_args?(parsers, other.parsers) { |one, two| one.unchanged?(two) }
      end

      # Collects and returns all the contacts from all the answer parts.
      #
      # @return [Array<Whois::Aswer::Contact>]
      #
      # @see Whois::Answer#contacts?
      # @see Whois::Answer::Parser::Base#contacts?
      #
      def contacts
        parsers.inject([]) { |all, parser| all.concat(parser.contacts) }
      end

      # Loop through all the answer parts to check if at least
      # one part is a throttle response.
      #
      # @return [Boolean]
      #
      # @see Whois::Answer#throttle?
      # @see Whois::Answer::Parser::Base#throttle?
      #
      def throttle?
        parsers.any?(&:throttle?)
      end


      private

        def method_missing(method, *args, &block)
          if PROPERTIES.include?(method)
            delegate_to_parsers(method, *args, &block)
          elsif METHODS.include?(method)
            delegate_to_parsers(method, *args, &block)
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
        # See also <tt>#select_parser</tt>.
        #
        # ==== Returns
        #
        # Returns an Array of Class,
        # where each item is the parts reverse-N specific parser Class.
        # Each Class is expected to be a child of Whois::Answer::Parser::Base.
        #
        # ==== Examples
        #
        #   parser.parts
        #   # => [whois.foo.com, whois.bar.com]
        #
        #   parser.parsers
        #   # => [Whois::Answer::Parser::WhoisBarCom, Whois::Answer::Parser::WhoisFooCom]
        #
        def init_parsers
          answer.parts.reverse.map { |part| self.class.parser_for(part) }
        end

        # Selects the first parser in <tt>#parsers</tt>
        # where <tt>given</tt> matches <tt>status</tt>.
        #
        # ==== Parameters
        #
        # property::  The Symbol property to search for.
        # status::    The Symbol status (default: :any).
        #
        # ==== Returns
        #
        # Whois::Answer::Parser::Base::
        #   The parser which satisfies given requirement.
        # nil::
        #   If the parser wasn't found.
        #
        # ==== Examples
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

        def all_with_args?(*args, &block)
          count = args.first.size
          index = 0

          while index < count
            return false unless yield(*args.map { |arg| arg[index] })
            index += 1
          end
          true
        end


      # Returns the proper parser instance for given <tt>part</tt>.
      # The parser class is selected according to the
      # value of the <tt>#host</tt> attribute for given <tt>part</tt>.
      #
      # ==== Parameters
      # 
      # part:: The Whois::Answer::Parser::Part to get the parser for.
      #
      # ==== Returns
      #
      # Returns an instance of the specific parser for given part.
      # The instance is expected to be a child of Whois::Answer::Parser::Base.
      # 
      # ==== Examples
      #
      #   # Parser for a known host
      #   Parser.parser_for("whois.example.com")
      #   #<Whois::Answer::Parser::WhoisExampleCom>
      #
      #   # Parser for an unknown host
      #   Parser.parser_for("missing.example.com")
      #   #<Whois::Answer::Parser::Blank>
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
      # ==== Parameters
      #
      # host:: A String with the host.
      #
      # ==== Returns
      #
      # Returns an instance of Class representing the parser Class
      # corresponding to <tt>host</tt>.
      # If <tt>host</tt> doesn't have a specific parser implementation,
      # then returns the Whois::Answer::Parser::Blank Class.
      # The Class is expected to be a child of Whois::Answer::Parser::Base.
      #
      # ==== Examples
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
      # ==== Parameters
      #
      # host:: A String with the host.
      #
      # ==== Examples
      #
      #   Parser.host_to_parser("whois.nic.it")
      #   # => "WhoisNicIt"
      #
      #   Parser.host_to_parser("whois.nic-info.it")
      #   # => "WhoisNicInfoIt"
      #
      # Returns a String with the class name.
      def self.host_to_parser(host)
        host.to_s.
          gsub(/[.-]/, '_').
          gsub(/(?:^|_)(.)/)  { $1.upcase }
      end

      # Requires the file at <tt>whois/answer/parser/#{name}</tt>.
      #
      # ==== Parameters
      #
      # name:: A string with the file name.
      #
      # ==== Returns
      #
      # Nothing.
      #
      def self.autoload(name)
        file = "whois/answer/parser/#{name}"
        require file
      end

    end

  end
end