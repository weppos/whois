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


require 'whois/answer/parser'
require 'whois/answer/parser/base'


module Whois

  class Answer

    # @return [Whois::Server] The server that originated this answer.
    attr_reader :server

    # @return [Array<Whois::Answer::Part>] The parts that compose this answer.
    attr_reader :parts


    # Initializes a new instance with given +server+ and +parts+.
    #
    # @param  [Whois::Server] server
    # @param  [Array<Whois::Answer::Part>] parts
    #
    def initialize(server, parts)
      @parts  = parts
      @server = server
    end


    # Checks if this class respond to given method.
    #
    # Overrides the default implementation to add support
    # for {PROPERTIES} and {METHODS}.
    #
    # @returns [Boolean]
    def respond_to?(symbol, include_private = false)
      super || Parser::PROPERTIES.include?(symbol) || Parser::METHODS.include?(symbol)
    end

    # Returns a String representation of this answer.
    #
    # @return [String] The answer content.
    def to_s
      content.to_s
    end

    # Returns a human-readable representation of this answer.
    #
    # @return [String] The result of {#inspect} on content.
    def inspect
      content.inspect
    end

    # Returns true if the <tt>object</tt> is the same object,
    # or is a string and has the same content.
    #
    # @param  [Whois::Answer] other The answer to compare.
    # @return [Boolean]
    def ==(other)
      if equal?(other)
        return true
      end
      if other.is_a?(self.class)
        return to_s == other.to_s
      end
      if other.is_a?(String)
        Whois.deprecate "Comparing an answer with a String is deprecated and will be removed in Whois 2.1."
        return to_s == other.to_s
      end
      false
    end

    alias_method :eql?, :==


    # Invokes {#match} on answer {#content}
    # and returns the match as <tt>MatchData</tt> or <tt>nil</tt>.
    #
    # @param  [Regexp, String] match
    # @return [MatchData] If pattern matches #content
    # @return [nil] If pattern doesn't match #content
    #
    # @see String#match
    #
    def match(pattern)
      content.match(pattern)
    end

    # Invokes {#match} and returns <tt>true</tt> if <tt>pattern</tt>
    # matches {#content}, <tt>false</tt> otherwise.
    #
    # @param  [Regexp, String] match
    # @return [Boolean]
    #
    # @see #match
    #
    def match?(pattern)
      !content.match(pattern).nil?
    end

    # Joins and returns all answer parts into a single string
    # and separates each response with a newline character.
    #
    # @example Answer with one part
    #   answer = Whois::Answer.new([Whois::Answer::Part.new("First answer.")])
    #   answer.content
    #   # => "First answer."
    #
    # @example Answer with multiple parts
    #   answer = Whois::Answer.new([Whois::Answer::Part.new("First answer."), Whois::Answer::Part.new("Second answer.")])
    #   answer.content
    #   # => "First answer.\nSecond answer."
    #
    # @return [String] The content of this answer.
    #
    def content
      @content ||= parts.map(&:body).join("\n")
    end

    # Lazy-loads and returns the parser proxy for current answer.
    #
    # @return [Whois::Answer::Parser]
    def parser
      @parser ||= Parser.new(self)
    end


    # Returns a Hash containing all supported properties for this answer
    # along with corresponding values.
    #
    # @return [{ Symbol => Object }]
    def properties
      hash = {}
      Parser::PROPERTIES.each { |property| hash[property] = send(property) }
      hash
    end

    # Returns <tt>true</tt> if the <tt>property</tt> passed as symbol
    # is supported by any available parser for this answer.
    #
    # @param  [Symbol] property The name of the property to check.
    # @return [Boolean]
    #
    # @see Whois::Answer::Parser#property_supported?
    #
    def property_supported?(property)
      parser.property_supported?(property)
    end


    # Checks whether this {Answer} is different than +other+.
    #
    # Comparing the {Answer} content is not as trivial as you may think.
    # WHOIS servers can inject into the WHOIS response strings that changes at every request,
    # such as the timestamp the request was generated or the number of requests left
    # for your current IP.
    #
    # These strings causes a simple equal comparison to fail even if
    # the registry data is the same.
    #
    # This method should provide a bulletproof way to detect whether this answer
    # changed compared with +other+.
    #
    # @param  [Whois::Answer] other The other answer instance to compare.
    # @return [Boolean]
    #
    # @see Whois::Answer::Parser#changed?
    #
    def changed?(other)
      !unchanged?(other)
    end

    # The opposite of {#changed?}.
    #
    # @param  [Whois::Answer] other The other answer instance to compare.
    # @return [Boolean]
    #
    # @see Whois::Answer::Parser#unchanged?
    #
    def unchanged?(other)
      unless other.is_a?(self.class)
        raise(ArgumentError, "Can't compare `#{self.class}' with `#{other.class}'")
      end

      equal?(other) ||
      parser.unchanged?(other.parser)
    end

    # Collects and returns all the contacts.
    #
    # @return [Array<Whois::Answer::Contact>]
    #
    # @see Whois::Answer::Parser#contacts
    #
    def contacts
      parser.contacts
    end


    # Checks whether this is a throttle response.
    #
    # @return [Boolean]
    #
    # @see Whois::Answer::Parser#throttle?
    #
    def throttle?
      parser.throttle?
    end

    # Checks whether this is an incomplete response.
    #
    # @return [Boolean]
    #
    # @see Whois::Answer::Parser#incomplete?
    #
    def incomplete?
      parser.incomplete?
    end


    private

      # @api internal
      def self.define_property_method(method)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{method}(*args, &block)
            if property_supported?(:#{method})
              parser.#{method}(*args, &block)
            else
              nil
            end
          end
        RUBY
      end

      # @api internal
      def self.define_method_method(method)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{method}(*args, &block)
            if parser.respond_to?(:#{method})
              parser.#{method}(*args, &block)
            end
          end
        RUBY
      end

      # @api internal
      def self.define_question_method(method)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{method}?
            !#{method}.nil?
          end
        RUBY
      end

      # Delegates all method calls to the internal parser.
      def method_missing(method, *args, &block)
        if Parser::PROPERTIES.include?(method)
          self.class.define_property_method(method)
          send(method, *args, &block)
        elsif Parser::METHODS.include?(method)
          self.class.define_method_method(method)
          send(method, *args, &block)
        elsif method.to_s =~ /([a-z_]+)\?/ and (Parser::PROPERTIES + Parser::METHODS).include?($1.to_sym)
          self.class.define_question_method($1)
          send(method)
        else
          super
        end
      end

  end

end
