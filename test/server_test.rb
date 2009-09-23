require 'test_helper'

class ServerTest < Test::Unit::TestCase

  def test_guess_should_recognize_email
    Whois::Server.expects(:find_for_email).with("email@example.org").returns(true)
    assert Whois::Server.guess("email@example.org")
  end

  def test_guess_should_recognize_tld
    Whois::Server.expects(:find_for_tld).with("google.com").returns(true)
    assert Whois::Server.guess("google.com")
  end

  def test_guess_should_raise_servernotfound_with_unrecognized_query
    assert_raise(Whois::ServerNotFound) { Whois::Server.guess("xyz") }
  end


  def test_definitions
    assert_instance_of Hash, Whois::Server.definitions
  end

  def test_definitions_with_key
    assert_equal nil, Whois::Server.definitions(:foo)
    Whois::Server.define(:foo, ".foo", "whois.foo")
    assert_equal [[".foo", "whois.foo", {}]], Whois::Server.definitions(:foo)
  end


  def test_define_tld
    Whois::Server.define(:tld, ".foo", "whois.foo")
    assert_equal [".foo", "whois.foo", {}], Whois::Server.definitions[:tld].last
  end

  def test_define_tld_with_options
    Whois::Server.define(:tld, ".foo", "whois.foo", :foo => "bar")
    assert_equal [".foo", "whois.foo", { :foo => "bar" }], Whois::Server.definitions[:tld].last
  end


  def test_factory
    server = Whois::Server.factory(:tld, ".foo", "whois.foo")
    assert_instance_of Whois::Server::Adapters::Standard, server
  end

  def test_factory_with_adapter
    server = Whois::Server.factory(:tld, ".foo", "whois.foo", :adapter => Whois::Server::Adapters::None)
    assert_instance_of Whois::Server::Adapters::None, server
  end

  def test_factory_with_adapter_should_delete_adapter_option
    server = Whois::Server.factory(:tld, ".foo", "whois.foo", :adapter => Whois::Server::Adapters::None, :foo => "bar")
    assert_equal server.options, { :foo => "bar" } 
  end


end