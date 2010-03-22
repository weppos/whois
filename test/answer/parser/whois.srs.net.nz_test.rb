require 'test_helper'
require 'whois/answer/parser/whois.srs.net.nz.rb'

class AnswerParserWhoisSrsNetNzTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisSrsNetNz
    @host   = "whois.srs.net.nz"
  end


  def test_status
    assert_equal  "Active",
                  @klass.new(load_part('/registered.txt')).status
    assert_equal  "Available",
                  @klass.new(load_part('/available.txt')).status
    assert_equal  "Invalid characters in query string",
                  @klass.new(load_part('/invalid.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/registered.txt')).available?
    assert  @klass.new(load_part('/available.txt')).available?
    assert !@klass.new(load_part('/invalid.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/registered.txt')).registered?
    assert !@klass.new(load_part('/available.txt')).registered?
    assert !@klass.new(load_part('/invalid.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("1999-02-17 00:00:00 +13:00"),
                  @klass.new(load_part('/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/invalid.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2010-01-16 23:23:15 +13:00"),
                  @klass.new(load_part('/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/invalid.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2011-02-17 00:00:00 +13:00"),
                  @klass.new(load_part('/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/invalid.txt')).expires_on
  end


  def test_nameservers
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/invalid.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end