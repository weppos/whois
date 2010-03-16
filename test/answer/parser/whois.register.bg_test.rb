require 'test_helper'
require 'whois/answer/parser/whois.register.bg.rb'

class AnswerParserWhoisRegisterBgTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisRegisterBg
    @host   = "whois.register.bg"
  end


  def test_status
    assert_equal  :registered,
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
    assert_equal  Time.parse("2003-06-30 00:00:00 EEST"),
                  @klass.new(load_part('/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).created_on
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).updated_on }
  end

  def test_expires_on
    assert_equal  Time.parse("2010-06-30 00:00:00 EEST"),
                  @klass.new(load_part('/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).expires_on
  end


  def test_nameservers
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = %w( ns4.google.com ns1.google.com ns3.google.com ns2.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end
