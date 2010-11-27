require "rspec"
require "whois"

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.expand_path("../", __FILE__)
end

module Helpers

  # Temporary resets Server @@definitions
  # to let the test setup a custom definition list.
  def with_definitions(&block)
    @_definitions = Whois::Server.definitions
    Whois::Server.send :class_variable_set, :@@definitions, { :tld => [], :ipv4 =>[], :ipv6 => [] }
    yield
  ensure
    Whois::Server.send :class_variable_set, :@@definitions, @_definitions
  end

  # Temporary resets parser @@registry
  # to let the test setup a custom registry.
  def with_registry(&block)
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
    File.join(TEST_ROOT, "fixtures", *names)
  end

end

module ConnectivityHelpers
  def need_connectivity(&block)
    if connectivity_available?
      yield
    end
  end

  def connectivity_available?
    ENV["ONLINE"].to_i == 1
  end
end

RSpec.configure do |config|
  config.mock_with :mocha
  config.include Helpers
  config.extend ConnectivityHelpers
end
