require "rspec"
require "whois"

module Helpers
  def with_definitions(&block)
    @_definitions = Whois::Server.definitions
    Whois::Server.send :class_variable_set, :@@definitions, { :tld => [], :ipv4 =>[], :ipv6 => [] }
    yield
  ensure
    Whois::Server.send :class_variable_set, :@@definitions, @_definitions
  end
end

RSpec.configure do |config|
  config.mock_with :mocha
  config.include Helpers
end
