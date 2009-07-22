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