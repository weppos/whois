module SpecHelper

  private

    # Temporary resets Server @@definitions
    # to let the test setup a custom definition list.
    def with_definitions
      definitions_setup
      yield
    ensure
      definitions_teardown
    end

    def definitions_setup
      @_definitions = Whois::Server.definitions
      Whois::Server.send :class_variable_set, :@@definitions, { :tld => [], :ipv4 =>[], :ipv6 => [] }
    end

    def definitions_teardown
      Whois::Server.send :class_variable_set, :@@definitions, @_definitions
    end


    # Temporary resets parser @@registry
    # to let the test setup a custom registry.
    def with_registry
      @_property_registry = Whois::Answer::Parser::Base.send :class_variable_get, :@@property_registry
      Whois::Answer::Parser::Base.send :class_variable_set, :@@property_registry, {}
      yield
    ensure
      Whois::Answer::Parser::Base.send :class_variable_set, :@@property_registry, @_property_registry
    end

    # Gets the currently described class.
    # Conversely to +subject+, it returns the class
    # instead of an instance.
    def klass
      described_class
    end

    def fixture(*names)
      File.join(SPEC_ROOT, "fixtures", *names)
    end

end

RSpec.configure do |config|
  config.include SpecHelper
end
