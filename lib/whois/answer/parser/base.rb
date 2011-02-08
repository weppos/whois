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


require 'time'
require 'whois/answer/contact'
require 'whois/answer/registrar'
require 'whois/answer/nameserver'
require 'whois/answer/parser/ast'


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

        @@property_registry = {}

        #
        # :call-seq:
        #   property_registry => hash
        #   property_registry(ParserClass) => hash
        #
        # Returns the <tt>@@property_registry</tt> if <tt>klass</tt> is nil,
        # otherwise returns the value in <tt>@@property_registry</tt> for given <tt>klass</tt>.
        # <tt>klass</tt> is expected to be a class name.
        #
        # Returned value is always a hash. If <tt>@@property_registry[klass]</tt>
        # doesn't exist, this method automatically initializes it to an empty Hash.
        #
        def self.property_registry(klass = nil)
          if klass.nil?
            @@property_registry
          else
            @@property_registry[klass] ||= {}
          end
        end

        # Returns the status for the <tt>property</tt> passed as symbol.
        #
        #   property_status(:disclaimer)
        #   # => nil
        #
        #   property_register(:discaimer, :supported) {}
        #   property_status(:disclaimer)
        #   # => :supported
        #
        def self.property_status(property)
          property = property.to_s.to_sym
          property_registry(self)[property]
        end

        # Returns <tt>true</tt> if the <tt>property</tt> passed as symbol
        # is registered in the <tt>property_registry</tt> for current parser.
        #
        #   property_registered?(:disclaimer)
        #   # => false
        #
        #   property_register(:discaimer) {}
        #   property_registered?(:disclaimer)
        #   # => true
        #
        def self.property_registered?(property, status = :any)
          property = property.to_s.to_sym
          if status == :any
            property_registry(self).key?(property)
          else
            property_registry(self)[property] == status
          end
        end

        # Creates a new method called <tt>property</tt>
        # with the content of <tt>block</tt> and registers
        # the <tt>property</tt> in the {@@property_registry}
        # with given <tt>status</tt>.
        #
        # @param  [Symbol] property
        # @param  [Symbol] status
        #
        # @return [void]
        #
        #
        # @example Defining a simple property
        #
        #   property_register(:disclaimer, :supported) do
        #     ...
        #   end
        #
        #   respond_to?(:disclaimer)
        #   # =>true
        #
        #   property_registered?(:disclaimer)
        #   # => true
        #
        # @example Defining a property with arguments
        #
        #   property_register(:disclaimer, :supported) do |arg1|
        #     ...
        #   end
        #
        def self.property_register(property, status, &block)
          property = property.to_s.to_sym
          property_registry(self).merge!({ property => status })

          if block_given?
            define_method("internal_#{property}", &block)

            class_eval <<-RUBY, __FILE__, __LINE__ + 1
              private :"internal_#{property}"

              def #{property}(*args)
                cached_properties_fetch(:#{property}) { internal_#{property}(*args) }
              end
            RUBY
          end

          self
        end

        # @deprecated Use {Whois::Answer::Parser::Base.property_register}.
        def self.register_property(property, status, &block)
          Whois.deprecate "#{self.class}.register_property will be removed in Whois 2.1. Use #{self.class}.property_register."
          property_register(property, status, &block)
        end


        # Registers a <tt>property</tt> as <tt>:not_implemented</tt>
        # and defines a method which will raise a <tt>PropertyNotImplemented</tt> error.
        #
        #   # Defines a not implemented property called :disclaimer.
        #   property_not_implemented(:disclaimer) do
        #     ...
        #   end
        #
        #   # def disclaimer
        #   #   raise PropertyNotImplemented, "You should overwrite this method."
        #   # end
        #
        def self.property_not_implemented(property)
          property_register(property, :not_implemented) do
            raise PropertyNotSupported
          end
        end

        # Registers a <tt>property</tt> as <tt>:not_supported</tt>
        # and defines a method which will raise a <tt>PropertyNotSupported</tt> error.
        #
        #   # Defines an unsupported property called :disclaimer.
        #   property_not_supported(:disclaimer) do
        #     ...
        #   end
        #
        #   # def disclaimer
        #   #   raise PropertyNotSupported
        #   # end
        #
        def self.property_not_supported(property)
          property_register(property, :not_supported) do
            raise PropertyNotSupported
          end
        end

        # Registers a <tt>property</tt> as <tt>:supported</tt>
        # and defines a method with the content of the block.
        #
        #   # Defines a supported property called :disclaimer.
        #   property_supported(:disclaimer) do
        #     ...
        #   end
        #
        #   # def disclaimer
        #   #   ...
        #   # end
        #
        def self.property_supported(property, &block)
          property_register(property, :supported, &block)
        end

        # Returns <tt>true</tt> if the <tt>property</tt> passed as symbol
        # is supported by the current parser.
        #
        # @param  [Symbol] property The name of the property to check.
        # @return [Boolean]
        #
        def property_supported?(property)
          self.class.property_registered?(property, :supported)
        end


        # @return [Whois::Answer::Part] The part referenced by this parser.
        attr_reader :part

        # Initializes a new parser with given +part+.
        #
        # @param  [Whois::Answer::Part] part
        #
        def initialize(part)
          @part = part
          @cached_properties = {}
        end


        # This is an internal method primary used as a common access point
        # to get the content to be parsed as a string.
        #
        # The main reason behind this method is because, in the past,
        # the internal representation of the data to be parsed changed
        # several times, and I always had to rewrite all single parsers
        # in order to reflect these changes.
        # Now, as far as the parser access the data via the content method,
        # there's no need to change each single implementation
        # in case the content source changes.
        #
        # That said, the only constraints about this method
        # is to return the data to be parsed as string.
        #
        # @return [String] The part body.
        def content
          part.body
        end



        # @group Methods

        Whois::Answer::Parser::PROPERTIES.each do |property|
          property_not_implemented(property)
        end

        # @properties


        # @group Methods

        # Checks whether the content of this part is different than +other+.
        #
        # Comparing a WHOIS response is not as trivial as you may think.
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
        # @param  [Base] other The other parser instance to compare.
        # @return [Boolean]
        #
        # @see Whois::Answer#changed?
        # @see Whois::Answer::Parser#changed?
        #
        def changed?(other)
          !unchanged?(other)
        end

        # The opposite of {#changed?}.
        #
        # @param  [Base] other The other parser instance to compare.
        # @return [Boolean]
        #
        # @see Whois::Answer#unchanged?
        # @see Whois::Answer::Parser#unchanged?
        #
        def unchanged?(other)
          unless other.is_a?(self.class)
            raise(ArgumentError, "Can't compare `#{self.class}' with `#{other.class}'")
          end

          equal?(other) ||
          content_for_scanner == other.content_for_scanner
        end

        # Collects and returns all the available contacts.
        #
        # @return [Array<Whois::Answer::Contact>]
        #
        # @see Whois::Answer#contacts
        # @see Whois::Answer::Parser#contacts
        #
        def contacts
          contacts = []
          contacts.concat(registrant_contact.is_a?(Array) ? registrant_contact : [registrant_contact]) if property_supported?(:registrant_contact)
          contacts.concat(admin_contact.is_a?(Array) ? admin_contact : [admin_contact]) if property_supported?(:admin_contact)
          contacts.concat(technical_contact.is_a?(Array) ? technical_contact : [technical_contact]) if property_supported?(:technical_contact)
          contacts.compact
        end

        # @endgroup


        # @group Response

        # Checks whether this is a throttle response.
        # The default implementation always returns +nil+.
        #
        # @return [nil, false]
        #
        # @abstract This method returns nil by default.
        #
        # @see Whois::Answer#throttle?
        # @see Whois::Answer::Parser#throttle?
        #
        def throttle?
          nil
        end

        # Checks whether this is an incomplete response.
        # The default implementation always returns +nil+.
        #
        # @return [nil, false]
        #
        # @abstract This method returns nil by default.
        #
        # @see Whois::Answer#incomplete?
        # @see Whois::Answer::Parser#incomplete?
        #
        def incomplete?
          nil
        end

        # @endgroup


        protected

          def content_for_scanner
            @content_for_scanner ||= content.to_s.gsub(/\r\n/, "\n")
          end

          def cached_properties_fetch(key)
            if !@cached_properties.key?(key)
              @cached_properties[key] = yield
            end
            @cached_properties[key]
          end

      end

    end
  end
end
