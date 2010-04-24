require 'test_helper'
require 'whois/answer/parser/whois.za.net'

class AnswerParserWhoisZaNetTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisZaNet
    @host   = "whois.za.net"
  end


  def test_status
    assert_equal  :registered,
                  @klass.new(load_part('/registered.txt')).status
    assert_equal  :available,
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
    assert_equal  Time.parse("2002-03-29 22:03:53 GMT"),
                  @klass.new(load_part('/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2002-03-29 22:03:53 GMT"),
                  @klass.new(load_part('/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).updated_on
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).expires_on }
  end


  def test_nameservers
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = %w( ns3.zoneedit.com ns5.zoneedit.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end
