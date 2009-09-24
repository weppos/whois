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

        def self.method_registry(key = nil)
          if key.nil?
            @@method_registry
          else
            @@method_registry[key] ||= []
          end
        end

        def self.method_registered?(key)
          method_registry(self).include?(key)
        end

        def self.register_method(method, &block)
          method_registry(self) << method
          define_method(method, &block)
        end

        def method_registered?(key)
          self.class.method_registered?(key)
        end

        def register_method(method, &block)
          self.class.register_method(method, &block)
        end

      end

    end
  end
end