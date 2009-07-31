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
    assert_instance_of Array, Server.definitions
  end
  

  def test_define
    Server.define(".foo", "whois.foo")
    assert_equal [".foo", "whois.foo", {}], Server.definitions.last
  end

  def test_define_with_options
    Server.define(".foo", "whois.foo", :foo => "bar")
    assert_equal [".foo", "whois.foo", { :foo => "bar" }], Server.definitions.last
  end


  def test_factory
    server = Server.factory(".foo", "whois.foo")
    assert_instance_of Server::Adapters::Standard, server
  end

  def test_factory_with_adapter
    server = Server.factory(".foo", "whois.foo", :adapter => Server::Adapters::None)
    assert_instance_of Server::Adapters::None, server
  end

  def test_factory_with_adapter_should_delete_adapter_option
    server = Server.factory(".foo", "whois.foo", :adapter => Server::Adapters::None, :foo => "bar")
    assert_equal server.options, { :foo => "bar" } 
  end


end