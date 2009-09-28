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


require 'strscan'
require 'time'
require 'whois/answer/contact'
require 'whois/answer/registrar'


module Whois
  class Answer
    class Parser

      #
      # = Base Answer Parser
      #
      # This class is intended to be the base abstract class for all
      # server-specific parser implementations.
      #
      # == Available Methods
      #
      # The Base class is for the most part auto-generated via meta programming.
      # This is the reason why RDoc can't detect and document all available methods.
      #
      class Base

        attr_reader :part


        def initialize(part)
          @part = part
        end

        ::Whois::Answer::Parser.registrable_methods.each do |method|
          define_method(method) do
            raise PropertyNotImplemented, "You should overwrite this method."
          end
        end


        # This is an internal method primaly used as a common access point
        # to get the content to be parsed as a string.
        #
        # The main reason behind this method is because I changed the internal
        # representation of the data to be parsed more than once
        # and I always had to rewrite all single parsers in order to reflect these changes.
        # Now, as far as the parser access the data via the content method,
        # there's no need to change each single implementation in case the content source changes.
        #
        # That said, the only constraints about this method is to return the data to be parsed as string.
        #
        def content
          part.response
        end


        @@method_registry = {}

        #
        # :call-seq:
        #   method_registry => hash
        #   method_registry(:key) => array
        #
        # Returns the <tt>@@method_registry</tt> if <tt>key</tt> is nil,
        # otherwise returns the value in <tt>@@method_registry</tt> for given <tt>key</tt>.
        #
        # <tt>@@method_registry</tt> is always a Hash while <tt>@@method_registry[:key]</tt>
        # is always an array. If <tt>@@method_registry[:key]</tt> doesn't exist, this method
        # automatically initializes it to an empty array.
        #
        def self.method_registry(key = nil)
          if key.nil?
            @@method_registry
          else
            @@method_registry[key] ||= []
          end
        end

        # Returns true if <tt>method</tt> is registered for current class.
        #
        #   method_registered?(:disclaimer)
        #   # => false
        #
        #   register_method(:discaimer) {}
        #   method_registered?(:disclaimer)
        #   # => true
        #
        def self.method_registered?(method)
          method_registry(self).include?(method)
        end

        #
        # :call-seq:
        #   register_method(:method) { }
        #   register_method(:method) { |parameter| ... }
        #   register_method(:method) { |parameter, ...| ... }
        #
        # Creates <tt>method</tt> with the content of <tt>block</tt>
        # and automatically registers <tt>method</tt> for current class.
        #
        #   register_method(:discaimer) do
        #     ...
        #   end
        #
        #   register_method(:changed?) do |other|
        #     ...
        #   end
        #
        #   method_registered?(:disclaimer)
        #   # => true
        #
        def self.register_method(method, &block)
          method_registry(self) << method
          define_method(method, &block)
        end

        # Instance-level version of <tt>Base.method_registered?</tt>.
        def method_registered?(method)
          self.class.method_registered?(method)
        end

        # Instance-level version of <tt>Base.register_method</tt>.
        def register_method(method, &block)
          self.class.register_method(method, &block)
        end

      end

    end
  end
end