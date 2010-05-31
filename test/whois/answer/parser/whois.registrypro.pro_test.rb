require 'test_helper'
require 'whois/answer/parser/whois.registrypro.pro'

class AnswerParserWhoisRegistryproProTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisRegistryproPro
    @host   = "whois.registrypro.pro"
  end


  def test_status
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = %w( serverDeleteProhibited )
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_variable_get(:"@status")

    parser    = @klass.new(load_part('/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_variable_get(:"@status")
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
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = Time.parse("2004-08-18 06:20:14 UTC")
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_variable_get(:"@created_on")

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_variable_get(:"@created_on")
  end

  def test_updated_on
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = Time.parse("2009-01-20 16:51:04 UTC")
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_variable_get(:"@updated_on")

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_variable_get(:"@updated_on")
  end

  def test_expires_on
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = Time.parse("2017-01-26 06:00:00 UTC")
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_variable_get(:"@expires_on")

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_variable_get(:"@expires_on")
  end


  def test_nameservers
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = %w( a.gtld.pro b.gtld.pro c.gtld.pro d.gtld.pro )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_variable_get(:"@nameservers")

    parser    = @klass.new(load_part('/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_variable_get(:"@nameservers")
  end

end