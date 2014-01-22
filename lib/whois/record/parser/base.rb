#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'time'
require 'whois/record/contact'
require 'whois/record/registrar'
require 'whois/record/nameserver'
require 'whois/record/scanners/scannable'


module Whois
  class Record
    class Parser

      # Represents the abstract base parser class for all
      # server-specific parser implementations.
      #
      # NOTE. This class is for the most part auto-generated via meta programming.
      # This is the reason why RDoc can't detect and document all available methods.
      #
      # @abstract
      #
      class Base

        class_attribute :_properties
        self._properties = {}

        # Returns the status for the +property+ passed as symbol.
        #
        # @param  [Symbol] property
        # @return [Symbol, nil]
        #
        # @example Undefined property
        #   property_state(:disclaimer)
        #   # => nil
        #
        # @example Defined property
        #   property_register(:disclaimer, Whois::Record::Parser::PROPERTY_STATE_SUPPORTED) {}
        #   property_state(:disclaimer)
        #   # => :supported
        #
        def self.property_state(property)
          self._properties[property]
        end

        # Check if the +property+ passed as symbol
        # is registered in the registry for current parser.
        #
        # @param  [Symbol] property
        # @param  [Symbol] status
        # @return [Boolean]
        #
        # @example Not-registered property
        #   property_state?(:disclaimer)
        #   # => false
        #
        # @example Registered property
        #   property_register(:disclaimer) {}
        #   property_state?(:disclaimer)
        #   # => true
        #
        def self.property_state?(property, status = :any)
          if status == :any
            self._properties.key?(property)
          else
            self._properties[property] == status
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
          self._properties = self._properties.merge({ property => status })
        end


        # Registers a <tt>property</tt> as "not implemented"
        # and defines the corresponding private _property_PROPERTY method.
        #
        # A "not implemented" property always raises a <tt>AttributeNotImplemented</tt> error
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
          property_register(property, Whois::Record::Parser::PROPERTY_STATE_NOT_IMPLEMENTED)

          class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def _property_#{property}(*args)
              raise AttributeNotImplemented
            end

            private :_property_#{property}
          RUBY
        end

        # Registers a <tt>property</tt> as "not supported"
        # and defines the corresponding private _property_PROPERTY method.
        #
        # A "not supported" property always raises a <tt>AttributeNotSupported</tt> error
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
          property_register(property, Whois::Record::Parser::PROPERTY_STATE_NOT_SUPPORTED)

          class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def _property_#{property}(*args)
              raise AttributeNotSupported
            end

            private :_property_#{property}
          RUBY
        end

        # Registers a <tt>property</tt> as "supported"
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
          property_register(property, Whois::Record::Parser::PROPERTY_STATE_SUPPORTED)

          define_method("_property_#{property}", &block)
          private :"_property_#{property}"
        end

        # Checks if the <tt>property</tt> passed as symbol
        # is supported by the current parser.
        #
        # @param  [Symbol] property The name of the property to check.
        # @return [Boolean]
        #
        def property_supported?(property)
          self.class.property_state?(property, Whois::Record::Parser::PROPERTY_STATE_SUPPORTED)
        end



        # @return [Whois::Record::Part] The part referenced by this parser.
        attr_reader :part

        # Initializes a new parser with given +part+.
        #
        # @param  [Whois::Record::Part] part
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

        # Check if the parser respond to +symbol+
        # and calls the method if defined.
        # The method referenced by the +symbol+
        # is supposed to be a question? method and to return a boolean.
        #
        # @param  [Symbol] symbol
        # @return [Boolean]
        #
        # @example
        #   is(:response_throttled?)
        #   # => true
        #
        # @api private
        def is(symbol)
          respond_to?(symbol) && send(symbol)
        end

        # @api private
        def validate!
          raise ResponseIsThrottled   if is(:response_throttled?)
          raise ResponseIsUnavailable if is(:response_unavailable?)
        end


        # @!group Properties

        Whois::Record::Parser::PROPERTIES.each do |property|
          class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def #{property}(*args)
              handle_property(:#{property}, *args)
            end
          RUBY

          property_not_implemented(property)
        end

        # @!endgroup


        # @!group Methods

        # Collects and returns all the available contacts.
        #
        # @return [Array<Whois::Record::Contact>]
        #
        # @see Whois::Record#contacts
        # @see Whois::Record::Parser#contacts
        #
        def contacts
          [:registrant_contacts, :admin_contacts, :technical_contacts].inject([]) do |contacts, property|
            contacts += send(property) if property_supported?(property)
            contacts
          end
        end

        # @!endgroup


        # @!group Response

        # Checks whether the content of this part is different than +other+.
        #
        # Comparing a WHOIS response is not as trivial as you may think.
        # WHOIS servers can inject into the WHOIS response strings
        # that changes at every request, such as the timestamp the request
        # was generated or the number of requests left for your current IP.
        #
        # These strings causes a simple equal comparison to fail even if
        # the registry data is the same.
        #
        # This method should provide a bulletproof way to detect
        # whether this record changed compared with +other+.
        #
        # @param  [Base] other The other parser instance to compare.
        # @return [Boolean]
        #
        # @see Whois::Record#changed?
        # @see Whois::Record::Parser#changed?
        #
        def changed?(other)
          !unchanged?(other)
        end

        # The opposite of {#changed?}.
        #
        # @param  [Base] other The other parser instance to compare.
        # @return [Boolean]
        #
        # @see Whois::Record#unchanged?
        # @see Whois::Record::Parser#unchanged?
        #
        def unchanged?(other)
          unless other.is_a?(self.class)
            raise(ArgumentError, "Can't compare `#{self.class}' with `#{other.class}'")
          end

          equal?(other) ||
          content_for_scanner == other.content_for_scanner
        end


        # Checks whether this is an incomplete response.
        #
        # @return [Boolean]
        #
        # @abstract This method is just a stub.
        #           Define it in your parser class.
        #
        # @see Whois::Record#response_incomplete?
        # @see Whois::Record::Parser#response_incomplete?
        #
        def response_incomplete?
        end

        # Checks whether this is a throttle response.
        #
        # @return [Boolean]
        #
        # @abstract This method is just a stub.
        #           Define it in your parser class.
        #
        # @see Whois::Record#response_throttled?
        # @see Whois::Record::Parser#response_throttled?
        #
        def response_throttled?
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
        # @see Whois::Record#response_unavailable?
        # @see Whois::Record::Parser#response_unavailable?
        #
        def response_unavailable?
        end

        # Let them be documented
        undef response_incomplete?
        undef response_throttled?
        undef response_unavailable?

        # @!endgroup


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

        def typecast(value, type)
          if Array == type
            Array.wrap(value)
          else
            value
          end
        end

        def handle_property(property, *args)
          unless property_supported?(property)
            return send(:"_property_#{property}", *args)
          end

          cached_properties_fetch(property) do
            validate!
            value = send(:"_property_#{property}", *args)

            case property.to_s
            when /_contacts$/, "nameservers"
              typecast(value, Array)
            else
              value
            end
          end
        end

      end

    end
  end
end
