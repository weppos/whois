require 'test_helper'
require 'whois/answer/parser/whois.adamsnames.tc'

class AnswerParserWhoisAdamsnamesTcTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisAdamsnamesTc
    @host   = "whois.adamsnames.tc"
  end

end

class AnswerParserWhoisAdamsnamesTcGdTest < AnswerParserWhoisAdamsnamesTcTest

  def test_status
    assert_equal  :registered,
                  @klass.new(load_part('/gd/registered.txt')).status
    assert_equal  :available,
                  @klass.new(load_part('/gd/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/gd/registered.txt')).available?
    assert  @klass.new(load_part('/gd/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/gd/registered.txt')).registered?
    assert !@klass.new(load_part('/gd/available.txt')).registered?
  end


  def test_created_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/gd/registered.txt')).created_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/gd/available.txt')).created_on }
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/gd/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/gd/available.txt')).updated_on }
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/gd/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/gd/available.txt')).expires_on }
  end


  def test_nameservers
    parser    = @klass.new(load_part('/gd/registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/gd/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end


end

class AnswerParserWhoisAdamsnamesTcTcTest < AnswerParserWhoisAdamsnamesTcTest

  def test_status
    assert_equal  :registered,
                  @klass.new(load_part('/tc/registered.txt')).status
    assert_equal  :available,
                  @klass.new(load_part('/tc/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/tc/registered.txt')).available?
    assert  @klass.new(load_part('/tc/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/tc/registered.txt')).registered?
    assert !@klass.new(load_part('/tc/available.txt')).registered?
  end


  def test_created_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/tc/registered.txt')).created_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/tc/available.txt')).created_on }
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/tc/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/tc/available.txt')).updated_on }
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/tc/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/tc/available.txt')).expires_on }
  end


  def test_nameservers
    parser    = @klass.new(load_part('/tc/registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
    
    parser    = @klass.new(load_part('/tc/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end

class AnswerParserWhoisAdamsnamesTcVgTest < AnswerParserWhoisAdamsnamesTcTest

  def test_status
    assert_equal  :registered,
                  @klass.new(load_part('/vg/registered.txt')).status
    assert_equal  :available,
                  @klass.new(load_part('/vg/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/vg/registered.txt')).available?
    assert  @klass.new(load_part('/vg/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/vg/registered.txt')).registered?
    assert !@klass.new(load_part('/vg/available.txt')).registered?
  end


  def test_created_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/vg/registered.txt')).created_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/vg/available.txt')).created_on }
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/vg/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/vg/available.txt')).updated_on }
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/vg/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/vg/available.txt')).expires_on }
  end


  def test_nameservers
    parser    = @klass.new(load_part('/vg/registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
    
    parser    = @klass.new(load_part('/vg/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end