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
        :contacts,
        # deprecated methods
        :registrant, :admin, :technical,
      ]

      @@properties = [
        :disclaimer,
        :domain, :domain_id,
        :referral_whois, :referral_url,
        :status, :available?, :registered?,
        :created_on, :updated_on, :expires_on,
        :registrar,
        :registrant_contact, :admin_contact, :technical_contact,
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


      # Collects and returns all the contacts from all parsers.
      def contacts
        parsers.inject([]) { |all, parser| all.concat(parser.contacts) }
      end


      private

        def method_missing(method, *args, &block)
          if Parser.properties.include?(method)
            delegate_to_parsers(method, *args, &block)
          elsif Parser::METHODS.include?(method)
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

        def select_parser(property, status = :any)
          parsers.each do |parser|
            return parser if parser.class.property_registered?(property, status)
          end
          nil
        end


      # Returns the proper <tt>Whois::Answer::Parser::Base</tt> instance
      # for given <tt>part</tt>.
      # The parser class depends on the <tt>Whois::Answer::Part</tt> host.
      def self.parser_for(part)
        parser_klass(part.host).new(part)
      end

      # Detects the proper parser class according to given <tt>host</tt>
      # and returns the class constant.
      # If no parser exists for <tt>host</tt>, then returns a generic
      # <tt>Whois::Answer::Parser::Blank</tt>.
      #
      # This method autoloads missing parser classes. If you want to define
      # a custom parser, simple make sure the class is loaded in the Ruby
      # environment before this method is called.
      #
      #   Parser.parser_klass("whois.missing.com")
      #   # => Whois::Answer::Parser::Blank
      #
      #   class Whois::Answer::Parser::WhoisMissingCom
      #   end
      #   Parser.parser_klass("whois.missing.com")
      #   # => Whois::Answer::Parser::WhoisMissingCom
      #
      def self.parser_klass(host)
        name = host_to_parser(host)
        Parser.const_defined?(name) || autoload(host)
        Parser.const_get(name)

      rescue LoadError
        Parser.const_defined?("Blank") || autoload("blank")
        Parser::Blank
      end

      # Converts <tt>host</tt> to a parser class name.
      # Note. Returns a <tt>String</tt>, not a <tt>Class</tt>.
      #
      #   Parser.host_to_parser("whois.nic.it")
      #   # => "WhoisNicIt"
      #   Parser.host_to_parser("whois.nic-info.it")
      #   # => "WhoisNicInfoIt"
      #
      def self.host_to_parser(host)
        host.to_s.
          gsub(/[.-]/, '_').
          gsub(/(?:^|_)(.)/)  { $1.upcase }
      end

      # Requires the file at "whois/answer/parser/#{name}".
      def self.autoload(name)
        file = "whois/answer/parser/#{name}"
        require file
      end

    end

  end
end