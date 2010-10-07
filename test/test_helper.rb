require 'test/unit'
require 'whois'
require 'rubygems'
require 'mocha'

class Test::Unit::TestCase

  TEST_ROOT = File.expand_path("../", __FILE__)

  def self.need_connectivity(&block)
    if connectivity_available?
      yield
    end
  end

  def self.connectivity_available?
    ENV["ONLINE"].to_i == 1
  end


  def with_definitions(&block)
    @_definitions = Whois::Server.definitions
    Whois::Server.send :class_variable_set, :@@definitions, { :tld => [], :ipv4 =>[], :ipv6 => [] }
    yield
  ensure
    Whois::Server.send :class_variable_set, :@@definitions, @_definitions
  end


  def fixture(*name)
    File.join(TEST_ROOT, "testcases", name)
  end

end


class Whois::Answer::Parser::TestCase < Test::Unit::TestCase

  def test_true
    true
  end

  def testcase_path
    File.expand_path(File.dirname(__FILE__) + "/testcases/responses/#{@host}")
  end


  protected

    def load_part(path)
      part(File.read(testcase_path + path), @host)
    end

    def part(*args)
      Whois::Answer::Part.new(*args)
    end

end