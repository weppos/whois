require 'test_helper'
require 'whois/answer/parser/whois.ripe.net.rb'


class AnswerParserWhoisRipeNetTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisRipeNet
    @host   = "whois.ripe.net"
  end


  def test_true
    assert true
  end

end

class AnswerParserWhoisRipeNetFoTest < AnswerParserWhoisRipeNetTest

  def test_status
    assert_equal  :registered,
                  @klass.new(load_part('/fo/registered.txt')).status
    assert_equal  :available,
                  @klass.new(load_part('/fo/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/fo/registered.txt')).available?
    assert  @klass.new(load_part('/fo/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/fo/registered.txt')).registered?
    assert !@klass.new(load_part('/fo/available.txt')).registered?
  end


  def test_created_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/fo/registered.txt')).created_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/fo/available.txt')).created_on }
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/fo/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/fo/available.txt')).updated_on }
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/fo/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/fo/available.txt')).expires_on }
  end

end

class AnswerParserWhoisRipeNetGmTest < AnswerParserWhoisRipeNetTest

  def test_status
    assert_equal  :registered,
                  @klass.new(load_part('/gm/registered.txt')).status
    assert_equal  :available,
                  @klass.new(load_part('/gm/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/gm/registered.txt')).available?
    assert  @klass.new(load_part('/gm/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/gm/registered.txt')).registered?
    assert !@klass.new(load_part('/gm/available.txt')).registered?
  end


  def test_created_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/gm/registered.txt')).created_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/gm/available.txt')).created_on }
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/gm/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/gm/available.txt')).updated_on }
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/gm/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/gm/available.txt')).expires_on }
  end

end

class AnswerParserWhoisRipeNetMcTest < AnswerParserWhoisRipeNetTest

  def test_status
    assert_equal  :registered,
                  @klass.new(load_part('/mc/registered.txt')).status
    assert_equal  :available,
                  @klass.new(load_part('/mc/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/mc/registered.txt')).available?
    assert  @klass.new(load_part('/mc/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/mc/registered.txt')).registered?
    assert !@klass.new(load_part('/mc/available.txt')).registered?
  end


  def test_created_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/mc/registered.txt')).created_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/mc/available.txt')).created_on }
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/mc/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/mc/available.txt')).updated_on }
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/mc/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/mc/available.txt')).expires_on }
  end

end

class AnswerParserWhoisRipeNetSmTest < AnswerParserWhoisRipeNetTest

  def test_status
    assert_equal  :registered,
                  @klass.new(load_part('/sm/registered.txt')).status
    assert_equal  :available,
                  @klass.new(load_part('/sm/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/sm/registered.txt')).available?
    assert  @klass.new(load_part('/sm/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/sm/registered.txt')).registered?
    assert !@klass.new(load_part('/sm/available.txt')).registered?
  end


  def test_created_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/sm/registered.txt')).created_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/sm/available.txt')).created_on }
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/sm/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/sm/available.txt')).updated_on }
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/sm/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/sm/available.txt')).expires_on }
  end

end

class AnswerParserWhoisRipeNetVaTest < AnswerParserWhoisRipeNetTest

  def test_status
    assert_equal  :registered,
                  @klass.new(load_part('/va/registered.txt')).status
    assert_equal  :available,
                  @klass.new(load_part('/va/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/va/registered.txt')).available?
    assert  @klass.new(load_part('/va/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/va/registered.txt')).registered?
    assert !@klass.new(load_part('/va/available.txt')).registered?
  end


  def test_created_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/va/registered.txt')).created_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/va/available.txt')).created_on }
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/va/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/va/available.txt')).updated_on }
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/va/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/va/available.txt')).expires_on }
  end

end

