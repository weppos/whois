require 'test_helper'

class WhoisTest < Test::Unit::TestCase
  include Whois

  def test_with_ipv4
    w  = Whois.new('72.17.207.99')

    response = w.search_whois

    assert_equal(response, w.all)
    assert_equal(IPAddr.new('72.17.207.99'), w.ip)
    assert_instance_of(Server::Arin, w.server)
    assert_nil w.host
  end

  def test_with_ipv4_as_ipaddr
    ip = IPAddr.new '72.17.207.99'
    w  = Whois.new(ip)

    response = w.search_whois

    assert_equal(response, w.all)
    assert_equal(IPAddr.new('72.17.207.99'), w.ip)
    assert_instance_of(Server::Arin, w.server)
    assert_nil w.host
  end

  def test_with_ipv6
    w  = Whois.new('2001:db8::1428:57ab')

    response = w.search_whois

    assert_equal(response, w.all)
    assert_equal(IPAddr.new('2001:db8::1428:57ab'), w.ip)
    assert_instance_of(Server::Apnic, w.server)
    assert_nil w.host
  end

  def test_with_ipv6_as_ipaddr
    ip = IPAddr.new '2001:db8::1428:57ab'
    w  = Whois.new(ip)

    response = w.search_whois

    assert_equal(response, w.all)
    assert_equal(IPAddr.new('2001:db8::1428:57ab'), w.ip)
    assert_instance_of(Server::Apnic, w.server)
    assert_nil w.host
  end

end