#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client.
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
    
    # Returns true if the <tt>object</tt> is the same object,
    # or is a string and has the same content.
    def ==(other)
      (other.equal?(self)) ||
      # This option should be deprecated
      (other.instance_of?(String) && other == self.to_s) ||
      (other.instance_of?(Answer) && other.to_s == self.to_s)
    end
    
    # Delegates to ==.
    def eql?(other)
      self == other
    end


    # Returns the content of this answer as a string.
    # This method joins all answer parts into a single string
    # and separates each response with a newline character.
    #
    #   answer = Whois::Answer.new([Whois::Answer::Part.new("First answer.")])
    #   answer.content
    #   # => "First answer."
    #
    #   answer = Whois::Answer.new([Whois::Answer::Part.new("First answer."), Whois::Answer::Part.new("Second answer.")])
    #   answer.content
    #   # => "First answer.\nSecond answer."
    #
    def content
      @content ||= parts.map { |part| part.response }.join("\n")
    end

    # Returns whether this answer changed compared to <tt>other</tt>.
    #
    # Comparing the Answer contents is not always as trivial as it seems.
    # Whois servers sometimes inject dynamic method into the whois answer such as
    # the timestamp the request was generated.
    # This causes two answers to be different even if they actually should be considered equal
    # because the registry data didn't change.
    #
    # This method should provide a bulletproof way to detect whether this answer
    # changed if compared with <tt>other</tt>.
    def changed?(other)
      !unchanged?(other)
    end

    # The opposite of <tt>changed?</tt>.
    def unchanged?(other)
      self == other ||
      parser.unchanged?(other.parser)
    end


    # Invokes <tt>match</tt> and returns <tt>true</tt> if <tt>pattern</tt>
    # matches <tt>@content</tt>, <tt>false</tt> otherwise.
    def match?(pattern)
      !content.match(pattern).nil?
    end


    # Lazy-loads and returns a <tt>Whois::Answer::Parser</tt> proxy for current answer.
    def parser
      @parser ||= Parser.new(self)
    end


    protected
      
      # Delegates all method calls to the internal parser.
      def method_missing(method, *args, &block)
        if Parser.registrable_methods.include?(method)
          parser.send(method, *args, &block)
        else
          super
        end
      end
      
  end

end