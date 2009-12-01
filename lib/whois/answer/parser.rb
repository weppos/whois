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

      @@properties = [
        :disclaimer,
        :domain, :domain_id,
        :referral_whois, :referral_url,
        :status, :registered?, :available?,
        :created_on, :updated_on, :expires_on,
        :registrar, :registrant, :admin, :technical,
        :nameservers,
      ]

      # Returns an array containing the name of all properties
      # that can be registered and should be implemented by
      # server-specific parsers.
      def self.properties
        @@properties
      end

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
      
      def supported?(*args)
        ::Whois.deprecate "supported? is deprecated. Use property_supported? instead."
        property_supported?(*args)
      end


      protected

        def method_missing(method, *args, &block)
          if Parser.properties.include?(method)
            if parsers.empty?
              raise ParserError, "Unable to select a parser because the answer is empty"
            elsif parser = select_parser(method)
              parser.send(method, *args, &block)
            else
              raise PropertyNotSupported, "Unable to find a parser for `#{method}'"
            end
          else
            super
          end
        end

        # Loops through all answer parts, for each parts tries to guess
        # the appropriate Whois::Answer::Parser::<parser> if it exists
        # and returns the final array of server-specific parsers.
        #
        # Parsers are initialized in reverse order for performance reason.
        # See also <tt>select_parser</tt>.
        #
        #   parser.parts
        #   # => [whois.foo.com, whois.bar.com]
        #   parser.parsers
        #   # => [parser(whois.bar.com), parser(whois.foo.com)]
        #
        def init_parsers
          answer.parts.reverse.map { |part| self.class.parser_for(part) }
        end

        def select_parser(method)
          parsers.each do |parser|
            return parser if parser.method_registered?(method)
          end
          nil
        end


      def self.parser_for(part)
        parser_klass(part.host).new(part)
      end

      def self.parser_klass(host)
        name = host_to_parser(host)
        Parser.const_defined?(name) || autoload(host)
        Parser.const_get(name)

      rescue LoadError
        Parser.const_defined?("Blank") || autoload("blank")
        Parser::Blank
      end

      def self.host_to_parser(host)
        host.to_s.
          gsub(/\./, '_').
          gsub(/(?:^|_)(.)/)  { $1.upcase }
      end
      
      def self.autoload(name)
        file = "whois/answer/parser/#{name}"
        require file
      end

    end

  end
end