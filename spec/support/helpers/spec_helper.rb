module RSpecSupportSpecHelpers

  def fixture(*names)
    File.join(SPEC_ROOT, "fixtures", *names)
  end

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
    Whois::Server.send :class_variable_set, :@@definitions,
      { :tld => [], :ipv4 => [], :ipv6 => [], :asn16 => [], :asn32 => [] }
  end

  def definitions_teardown
    Whois::Server.send :class_variable_set, :@@definitions, @_definitions
  end

end

RSpec.configure do |config|
  config.include RSpecSupportSpecHelpers
end
