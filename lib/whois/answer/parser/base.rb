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


module Whois
  class Answer
    class Parser

      module Features
        autoload :Ast,      'whois/answer/parser/features/ast'
      end


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

        # Returns the <tt>@@property_registry</tt> if <tt>klass</tt> is nil,
        # otherwise returns the value in <tt>@@property_registry</tt> for given <tt>klass</tt>.
        # <tt>klass</tt> is expected to be a class name.
        #
        # Returned value is always a hash. If <tt>@@property_registry[klass]</tt>
        # doesn't exist, this method automatically initializes it to an empty Hash.
        #
        # @param  [Class] klass
        # @return [Hash]
        #
        # @example Get the full registry
        #   property_registry
        #
        # @example Get the registry for a specfic Class
        #   property_registry(ParserClass)
        #
        def self.property_registry(klass = nil)
          if klass.nil?
            @@property_registry
          else
            @@property_registry[klass] ||= {}
          end
        end

        # Returns the status for the +property+ passed as symbol.
        #
        # @param  [Symbol] property
        # @return [Symbol, nil]
        #
        # @example Undefined property
        #   property_status(:disclaimer)
        #   # => nil
        #
        # @example Defined property
        #   property_register(:discaimer, :supported) {}
        #   property_status(:disclaimer)
        #   # => :supported
        #
        def self.property_status(property)
          property_registry(self)[property]
        end

        # Check if the +property+ passed as symbol
        # is registered in the +property_registry+ for current parser.
        #
        # @param  [Symbol] property
        # @param  [Symbol] status
        # @return [Boolean]
        #
        # @example Not-registered property
        #   property_registered?(:disclaimer)
        #   # => false
        #
        # @example Registered property
        #   property_register(:discaimer) {}
        #   property_registered?(:disclaimer)
        #   # => true
        #
        def self.property_registered?(property, status = :any)
          if status == :any
            property_registry(self).key?(property)
          else
            property_registry(self)[property] == status
          end
        end

        # Registers a <tt>property</tt> in the registry.
        #
        # @param  [Symbol] property
        # @param  [Symbol] status
        #
        # @return [void]
        #
        def self.property_register(property, status)
          property_registry(self).merge!({ property => status })
        end


        # Registers a <tt>property</tt> as <tt>:not_implemented</tt>
        # and defines the corresponding private _property_PROPERTY method.
        #
        # A :not_implemented property always raises a <tt>PropertyNotImplemented</tt> error
        # when the property method is called.
        #
        # @param  [Symbol] property
        # @return [void]
        #
        # @example Defining a not implemented property
        #   # Defines a not implemented property called :disclaimer.
        #   property_not_implemented(:disclaimer)
        #
        def self.property_not_implemented(property)
          property_register(property, :not_implemented)

          class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def _property_#{property}(*args)
              raise PropertyNotImplemented
            end

            private :_property_#{property}
          RUBY
        end

        # Registers a <tt>property</tt> as <tt>:not_supported</tt>
        # and defines the corresponding private _property_PROPERTY method.
        #
        # A :not_implemented property always raises a <tt>PropertyNotSupported</tt> error
        # when the property method is called.
        #
        # @param  [Symbol] property
        # @return [void]
        #
        # @example Defining an unsupported property
        #   # Defines an unsupported property called :disclaimer.
        #   property_not_supported(:disclaimer)
        #
        def self.property_not_supported(property)
          property_register(property, :not_supported)

          class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def _property_#{property}(*args)
              raise PropertyNotSupported
            end

            private :_property_#{property}
          RUBY
        end

        # Registers a <tt>property</tt> as <tt>:supported</tt>
        # and defines the corresponding private _property_PROPERTY method.
        #
        # @param  [Symbol] property
        # @return [void]
        #
        # @example Defining a supported property
        #   # Defines a supported property called :disclaimer.
        #   property_supported(:disclaimer) do
        #     ...
        #   end
        #
        def self.property_supported(property, &block)
          property_register(property, :supported)

          define_method("_property_#{property}", &block)
          private :"_property_#{property}"

          # FIXME: move the typecast to a separate method.
          # Ideally, we can define the methods once in the base parser
          # and have #property_register to only define the _method.
          class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def #{property}(*args)
              cached_properties_fetch(:#{property}) do
                validate!
                value = _property_#{property}(*args)

                case "#{property}"
                when /_contacts$/, "nameservers"
                  typecast(value, Array)
                else
                  value
                end
              end
            end
          RUBY
        end

        # Checks if the <tt>property</tt> passed as symbol
        # is supported by the current parser.
        #
        # @param  [Symbol] property The name of the property to check.
        # @return [Boolean]
        #
        def property_supported?(property)
          self.class.property_registered?(property, :supported)
        end


        # @api internal
        def self.define_method_property(property)
          class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def #{property}(*args)
              _property_#{property}(*args)
            end
          RUBY
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

        # @api internal
        def is(symbol)
          respond_to?(symbol) && send(symbol)
        end

        # @api internal
        def validate!
          raise ResponseIsThrottled if is(:response_throttled?)
        end


        # @group Properties

        Whois::Answer::Parser::PROPERTIES.each do |property|
          define_method_property(property)

          property_not_implemented(property)
        end

        # @endgroup


        # @group Methods

        # Collects and returns all the available contacts.
        #
        # @return [Array<Whois::Answer::Contact>]
        #
        # @see Whois::Answer#contacts
        # @see Whois::Answer::Parser#contacts
        #
        def contacts
          [:registrant_contacts, :admin_contacts, :technical_contacts].inject([]) do |contacts, property|
            contacts += send(property) if property_supported?(property)
            contacts
          end
        end

        # @endgroup


        # @group Response

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

        # Checks whether this is a throttle response.
        #
        # @return [Boolean]
        #
        # @abstract This method is just a stub.
        #           Define it in your parser class.
        #
        # @see Whois::Answer#response_throttled?
        # @see Whois::Answer::Parser#response_throttled?
        #
        def response_throttled?
        end

        # Checks whether this is an incomplete response.
        #
        # @return [Boolean]
        #
        # @abstract This method is just a stub.
        #           Define it in your parser class.
        #
        # @see Whois::Answer#response_incomplete?
        # @see Whois::Answer::Parser#response_incomplete?
        #
        def response_incomplete?
        end

        # Checks whether this response contains a message
        # that can be reconducted to a "WHOIS Server Unavailable" status.
        #
        # Some WHOIS servers returns error messages
        # when they are experiencing failures.
        #
        # @return [Boolean]
        #
        # @abstract This method is just a stub.
        #           Define it in your parser class.
        #
        def response_unavailable?
        end

        # Let them be documented
        undef :response_incomplete?
        undef :response_throttled?
        undef :response_unavailable?

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

        private

          # @api internal
          def typecast(value, type)
            if Array == type
              Array.wrap(value)
            else
              value
            end
          end

      end

    end
  end
end
