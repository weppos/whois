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
