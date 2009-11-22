$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'test/unit'
require 'mocha'
require 'whois'


module ConnectivityTestHelper
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def need_connectivity(&block)
      if connectivity_available?
        yield
      end
    end

    def connectivity_available?
      ENV["ONLINE"].to_i == 1
    end

  end
end


class Test::Unit::TestCase
  include ConnectivityTestHelper
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