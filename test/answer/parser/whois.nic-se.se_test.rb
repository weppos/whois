require 'test_helper'
require 'whois/answer/parser/whois.nic-se.se.rb'

class AnswerParserWhoisNicSeSeTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicSeSe
    @host   = "whois.nic-se.se"
  end


  def test_status
    assert_equal  :active,
                  @klass.new(load_part('/registered.txt')).status
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/registered.txt')).available?
    assert  @klass.new(load_part('/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/registered.txt')).registered?
    assert !@klass.new(load_part('/available.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("2008-10-20"),
                  @klass.new(load_part('/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-08-01"),
                  @klass.new(load_part('/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2010-10-20"),
                  @klass.new(load_part('/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).expires_on
  end

  def test_nameservers
    assert_equal  %w(ns1.google.com ns2.google.com ns3.google.com ns4.google.com),
                  @klass.new(load_part('/registered.txt')).nameservers
    assert_equal  %w(),
                  @klass.new(load_part('/available.txt')).nameservers
  end

end