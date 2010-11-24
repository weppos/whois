require 'test_helper'

class Whois::Answer::NameserverTest < Test::Unit::TestCase

  def setup
    @klass = Whois::Answer::Nameserver
  end

  def test_initialize_with_empty_values
    instance = @klass.new
    assert_instance_of @klass, instance
    assert_equal nil, instance.name

    instance = @klass.new({})
    assert_instance_of @klass, instance
    assert_equal nil, instance.name
  end

  def test_initialize_with_params
    instance = @klass.new("ns1.example.com", "127.0.0.1")

    assert_equal "ns1.example.com",     instance.name
    assert_equal "127.0.0.1",           instance.ipv4
    assert_equal nil,                   instance.ipv6
  end

  def test_initialize_with_hash
    instance = @klass.new(:name => "ns1.example.com", :ipv4 => "127.0.0.1")

    assert_equal "ns1.example.com",     instance.name
    assert_equal "127.0.0.1",           instance.ipv4
    assert_equal nil,                   instance.ipv6
  end

  def test_initialize_with_block
    instance = @klass.new do |c|
      c.name  = "ns1.example.com"
      c.ipv4  = "127.0.0.1"
    end

    assert_equal "ns1.example.com",     instance.name
    assert_equal "127.0.0.1",           instance.ipv4
    assert_equal nil,                   instance.ipv6
  end

end
