require 'test_helper'

class ServerTest < Test::Unit::TestCase

  def setup
    Whois::Server.class_eval { class_variable_set("@@definitions", { :tld => [], :ipv4 =>[], :ipv6 => [] }) }
  end


  def test_guess_should_recognize_email
    Whois::Server.expects(:find_for_email).with("email@example.org").returns(true)
    assert Whois::Server.guess("email@example.org")
  end

  def test_guess_should_recognize_tld
    Whois::Server.expects(:find_for_tld).with("google.com").returns(true)
    assert Whois::Server.guess("google.com")
  end

  def test_guess_should_recognize_ipv4
    Whois::Server.expects(:find_for_ip).with("192.168.1.1").returns(true)
    assert Whois::Server.guess("192.168.1.1")
  end

  def test_guess_should_recognize_ipv6
    Whois::Server.expects(:find_for_ip).with("2001:0db8:85a3:0000:0000:8a2e:0370:7334").returns(true)
    assert Whois::Server.guess("2001:0db8:85a3:0000:0000:8a2e:0370:7334")
  end

  def test_guess_should_recognize_ipv6_with_zeros_group
    Whois::Server.expects(:find_for_ip).with("2002::1").returns(true)
    assert Whois::Server.guess("2002::1")
  end

  def test_guess_should_raise_servernotfound_with_unrecognized_query
    assert_raise(Whois::ServerNotFound){ Whois::Server.guess("xyz") }
  end


  def test_find_for_ipv4_should_lookup_definition_and_return_adapter
    Whois::Server.define(:ipv4, "192.168.1.0/10", "whois.foo")

    assert_equal Whois::Server.factory(:ipv4, "192.168.1.0/10", "whois.foo"), Whois::Server.guess("192.168.1.1")
  end

  def test_find_for_ipv4_should_raise_if_definition_is_not_found
    Whois::Server.define(:ipv4, "192.168.1.0/10", "whois.foo")

    assert_raise(Whois::AllocationUnknown) { Whois::Server.guess("192.168.0.1") }
  end

  def test_find_for_ipv6_should_lookup_definition_and_return_adapter
    Whois::Server.define(:ipv6, "2001:0200::/23", "whois.foo")

    assert_equal Whois::Server.factory(:ipv6, "2001:0200::/23", "whois.foo"), Whois::Server.guess("2001:0200::1")
  end

  def test_find_for_ipv4_should_raise_if_definition_is_not_found
    Whois::Server.define(:ipv6, "2001:0200::/23", "whois.foo")

    assert_raise(Whois::AllocationUnknown) { Whois::Server.guess("2002:0300::1") }
  end

  def test_find_for_tld_should_not_consider_dot_as_regexp_instruction
    Whois::Server.define(:tld, ".no.com", "whois.no.com")
    Whois::Server.define(:tld, ".com", "whois.com")

    assert_equal "whois.com", Whois::Server.guess("antoniocangiano.com").host
  end

  def test_find_for_ipv6_should_factory_ipv6_with_ipv4_compatibility
    Whois::Server.define(:ipv6, "::192.168.1.1", "whois.foo")
    Whois::Server.expects(:factory).with(:ipv6, any_parameters).returns(true)

    assert Whois::Server.guess("::192.168.1.1")
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

  def test_define_ipv4
    Whois::Server.define(:ipv4, ".foo", "whois.foo")
    assert_equal [".foo", "whois.foo", {}], Whois::Server.definitions[:ipv4].last
  end

  def test_define_ipv4_with_options
    Whois::Server.define(:ipv4, ".foo", "whois.foo", :foo => "bar")
    assert_equal [".foo", "whois.foo", { :foo => "bar" }], Whois::Server.definitions[:ipv4].last
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