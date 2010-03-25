require 'test_helper'
require 'whois/answer/parser/whois.ripn.net.rb'

class AnswerParserWhoisRipnNetTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisRipnNet
    @host   = "whois.ripn.net"
  end

end

class AnswerParserWhoisRipnNetRuTest < AnswerParserWhoisRipnNetTest

  def test_status
    assert_equal  %w(REGISTERED DELEGATED VERIFIED),
                  @klass.new(load_part('/ru/registered.txt')).status
    assert_equal  %w(),
                  @klass.new(load_part('/ru/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/ru/registered.txt')).available?
    assert  @klass.new(load_part('/ru/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/ru/registered.txt')).registered?
    assert !@klass.new(load_part('/ru/available.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("2004-03-04"),
                  @klass.new(load_part('/ru/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/ru/available.txt')).created_on
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/ru/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/ru/available.txt')).updated_on }
  end

  def test_expires_on
    assert_equal  Time.parse("2010-03-05"),
                  @klass.new(load_part('/ru/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/ru/available.txt')).expires_on
  end


  def test_nameservers
    parser    = @klass.new(load_part('/ru/registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/ru/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

  def test_nameservers_with_ip
    parser    = @klass.new(load_part('/ru/property_nameservers_with_ip.txt'))
    expected  = %w( ns.masterhost.ru ns1.masterhost.ru ns2.masterhost.ru )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end


class AnswerParserWhoisRipnNetSuTest < AnswerParserWhoisRipnNetTest

  def test_status
    assert_equal  %w(REGISTERED DELEGATED UNVERIFIED),
                  @klass.new(load_part('/su/registered.txt')).status
    assert_equal  %w(),
                  @klass.new(load_part('/su/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/su/registered.txt')).available?
    assert  @klass.new(load_part('/su/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/su/registered.txt')).registered?
    assert !@klass.new(load_part('/su/available.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("2005-10-16"),
                  @klass.new(load_part('/su/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/su/available.txt')).created_on
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/su/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/su/available.txt')).updated_on }
  end

  def test_expires_on
    assert_equal  Time.parse("2010-10-16"),
                  @klass.new(load_part('/su/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/su/available.txt')).expires_on
  end


  def test_nameservers
    parser    = @klass.new(load_part('/su/registered.txt'))
    expected  = %w( ns1073.hostgator.com ns1074.hostgator.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/su/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end
