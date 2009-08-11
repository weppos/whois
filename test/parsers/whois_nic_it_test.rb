require 'test_helper'
require 'whois/response/parsers/whois.nic.it.rb'

class WhoisNicItTest < Test::Unit::TestCase

  TESTCASE_PATH = File.expand_path(File.dirname(__FILE__) + '/../testcases/responses/it')

  def setup
    @klass    = Whois::Response::Parsers::WhoisNicIt
    @server   = Whois::Server.factory(:tld, ".it", "whois.nic.it")
    @response = Whois::Response
  end


  def test_available?
    assert  @klass.new(load_response('/available.txt')).available?
    assert !@klass.new(load_response('/registered.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_response('/registered.txt')).registered?
    assert !@klass.new(load_response('/available.txt')).registered?
  end

  def test_status
    assert_equal  :active,
                  @klass.new(load_response('/status_active.txt')).status
    assert_equal  :available,
                  @klass.new(load_response('/status_available.txt')).status
  end


  def test_created_on
    assert_equal  Time.parse("1999-12-10 00:00:00"),
                  @klass.new(load_response('/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_response('/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2008-11-27 16:47:22"),
                  @klass.new(load_response('/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_response('/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2009-11-27"),
                  @klass.new(load_response('/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_response('/available.txt')).expires_on
  end



  protected
  
    def load_response(path)
      @response.new(File.read(TESTCASE_PATH + path), @server)
    end

end