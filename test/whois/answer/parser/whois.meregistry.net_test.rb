require 'test_helper'
require 'whois/answer/parser/whois.meregistry.net'

class AnswerParserWhoisMeregistryNetTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisMeregistryNet
    @host   = "whois.meregistry.net"
  end


  def test_status
    parser    = @klass.new(load_part('registered.txt'))
    expected  = ["CLIENT DELETE PROHIBITED", "CLIENT TRANSFER PROHIBITED", "CLIENT UPDATE PROHIBITED"]
    assert_equal_and_cached expected, parser, :status

    parser    = @klass.new(load_part('available.txt'))
    expected  = []
    assert_equal_and_cached expected, parser, :status
  end

  def test_available?
    parser    = @klass.new(load_part('registered.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :available?

    parser    = @klass.new(load_part('available.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :available?
  end

  def test_registered?
    parser    = @klass.new(load_part('registered.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :registered?

    parser    = @klass.new(load_part('available.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :registered?
  end


  def test_created_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2008-06-13 17:17:40 UTC")
    assert_equal_and_cached expected, parser, :created_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :created_on
  end

  def test_updated_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2009-06-10 11:00:13 UTC")
    assert_equal_and_cached expected, parser, :updated_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :updated_on
  end

  def test_expires_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2013-06-13 17:17:40 UTC")
    assert_equal_and_cached expected, parser, :expires_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :expires_on
  end


  def test_nameservers
    parser    = @klass.new(load_part('registered.txt'))
    expected  = %w( ns2.google.com ns1.google.com ns4.google.com ns3.google.com ).map { |ns| nameserver(ns) }
    assert_equal_and_cached expected, parser, :nameservers

    parser    = @klass.new(load_part('available.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers
  end

  def test_nameservers_are_missing
    parser    = @klass.new(load_part('property_nameservers_is_missing.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers
  end

end
