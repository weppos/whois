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

    attr_reader :server
    attr_reader :parts

    def initialize(server, parts)
      @parts  = parts
      @server = server
    end


    def to_s
      content.to_s
    end

    def inspect
      content.inspect
    end

    # Invokes <tt>match</tt> on answer <tt>@content</tt>
    # and returns the <tt>MatchData</tt> or <tt>nil</tt>.
    def match(pattern)
      content.match(pattern)
    end

    # Invokes <tt>match</tt> and returns <tt>true</tt> if <tt>pattern</tt>
    # matches <tt>@content</tt>, <tt>false</tt> otherwise.
    def match?(pattern)
      !content.match(pattern).nil?
    end

    # Returns true if the <tt>object</tt> is the same object,
    # or is a string and has the same content.
    def ==(other)
      (other.equal?(self)) ||
      # TODO: This option should be deprecated
      (other.is_a?(String) && other == self.to_s) ||
      (other.is_a?(Answer) && other.to_s == self.to_s)
    end

    alias_method :eql?, :==


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
    # @return [Hash]
    def properties
      hash = {}
      Parser::PROPERTIES.each { |property| hash[property] = send(property) }
      hash
    end

    # Returns <tt>true</tt> if the <tt>property</tt> passed as symbol
    # is supported by any available parser for this answer.
    # See also <tt>Whois::Answer::Parser.supported?</tt>.
    #
    # @param  [Symbol] property - The name of the property to check.
    # @return [Boolean]
    #
    # @see Whois::Answer::Parser#property_supported?
    #
    def property_supported?(property)
      parser.property_supported?(property)
    end


    # Checks whether this Answer is different than +other+.
    #
    # Comparing the Answer content is not as trivial as you may think.
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
    # @return [Array<Whois::Aswer::Contact>]
    #
    # @see Whois::Answer::Parser#contacts?
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


    protected

      # Delegates all method calls to the internal parser.
      def method_missing(method, *args, &block)
        if Parser::PROPERTIES.include?(method)
          self.class.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{method}(*args, &block)
              if property_supported?(:#{method})
                parser.#{method}(*args, &block)
              else
                nil
              end
            end
          RUBY
          send(method, *args, &block)

        elsif Parser::METHODS.include?(method)
          self.class.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{method}(*args, &block)
              if parser.respond_to?(:#{method})
                parser.#{method}(*args, &block)
              end
            end
          RUBY
          send(method, *args, &block)

        elsif method.to_s =~ /([a-z_]+)\?/ and (Parser::PROPERTIES + Parser::METHODS).include?($1.to_sym)
          self.class.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{$1}?
              !#{$1}.nil?
            end
          RUBY
          send($1)

        else
          super
        end
      end

  end

end
