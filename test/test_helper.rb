require "pathname"
require "test/unit"
require "whois"
require "rubygems"
require "mocha"

class Test::Unit::TestCase

  TEST_ROOT = File.expand_path("../", __FILE__)

  def self.need_connectivity
    if connectivity_available?
      yield
    end
  end

  def self.connectivity_available?
    ENV["ONLINE"].to_i == 1
  end


  def with_definitions
    @_definitions = Whois::Server.definitions
    Whois::Server.send :class_variable_set, :@@definitions, { :tld => [], :ipv4 =>[], :ipv6 => [] }
    yield
  ensure
    Whois::Server.send :class_variable_set, :@@definitions, @_definitions
  end


  def fixture(*names)
    File.join(TEST_ROOT, "..", "spec", "fixtures", *names)
  end

end


class Whois::Answer::Parser::TestCase < Test::Unit::TestCase

  def test_true
    true
  end


  protected

    def load_part(path)
      part(File.read(fixture("responses", @host.to_s, @suffix.to_s, @schema.to_s, path)), @host)
    end

    def part(*args)
      Whois::Answer::Part.new(*args)
    end

end