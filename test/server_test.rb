require 'test_helper'

class ServerTest < Test::Unit::TestCase
  include Whois

  def test_guess_should_recognize_email
    Server.expects(:find_for_email).with("email@example.org").returns(true)
    assert Server.guess("email@example.org")
  end

  def test_guess_should_recognize_tld
    Server.expects(:find_for_tld).with("google.com").returns(true)
    assert Server.guess("google.com")
  end

  def test_guess_should_raise_servernotfound_with_unrecognized_query
    assert_raise(ServerNotFound){ Server.guess("xyz") }
  end


  def test_definitions
    assert_instance_of Hash, Server.definitions
  end

  def test_definitions_with_key
    assert_equal nil, Server.definitions(:foo)
    Server.define(:foo, ".foo", "whois.foo")
    assert_equal [[".foo", "whois.foo", {}]], Server.definitions(:foo)
  end


  def test_define_tld
    Server.define(:tld, ".foo", "whois.foo")
    assert_equal [".foo", "whois.foo", {}], Server.definitions[:tld].last
  end

  def test_define_tld_with_options
    Server.define(:tld, ".foo", "whois.foo", :foo => "bar")
    assert_equal [".foo", "whois.foo", { :foo => "bar" }], Server.definitions[:tld].last
  end


  def test_factory
    server = Server.factory(:tld, ".foo", "whois.foo")
    assert_instance_of Server::Adapters::Standard, server
  end

  def test_factory_with_adapter
    server = Server.factory(:tld, ".foo", "whois.foo", :adapter => Server::Adapters::None)
    assert_instance_of Server::Adapters::None, server
  end

  def test_factory_with_adapter_should_delete_adapter_option
    server = Server.factory(:tld, ".foo", "whois.foo", :adapter => Server::Adapters::None, :foo => "bar")
    assert_equal server.options, { :foo => "bar" } 
  end


end