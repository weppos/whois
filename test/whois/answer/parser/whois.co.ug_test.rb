require 'test_helper'
require 'whois/answer/parser/whois.co.ug'

class AnswerParserWhoisCoUgTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisCoUg
    @host   = "whois.co.ug"
  end


  def test_status
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = "ACTIVE"
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
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
    
    expected  = Time.mktime(2001, 4, 2, 0, 0, 0)
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }
  end

  def test_updated_on
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = Time.gm(2009, 11, 10, 14, 6, 58)
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }
  end

  def test_expires_on
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = Time.mktime(2018, 4, 7)
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }
  end

  def test_nameservers
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = %w[ns1.cfi.co.ug ns2.cfi.co.ug ns3.cfi.co.ug]
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = []
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end
