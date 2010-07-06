require 'test_helper'
require 'whois/answer/parser/whois.jprs.jp'

class AnswerParserWhoisJprsJpTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisJprsJp
    @host   = "whois.jprs.jp"
  end

end

class AnswerParserWhoisJprsJpJpTest < AnswerParserWhoisJprsJpTest

  def test_status
    parser    = @klass.new(load_part('/jp/registered.txt'))
    expected  = "Active"
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/jp/available.txt'))
    expected  = nil
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    assert !@klass.new(load_part('/jp/registered.txt')).available?
    assert  @klass.new(load_part('/jp/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/jp/registered.txt')).registered?
    assert !@klass.new(load_part('/jp/available.txt')).registered?
  end


  def test_created_on
    parser    = @klass.new(load_part('/jp/registered.txt'))
    expected  = Time.parse("2005-05-30")
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }

    parser    = @klass.new(load_part('/jp/available.txt'))
    expected  = nil
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }
  end

  def test_updated_on
    parser    = @klass.new(load_part('/jp/registered.txt'))
    # TODO: timezone
    # JST timezone is ignored by Time.parse
    expected  = Time.parse("2009-06-01 01:05:04 JST")
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }

    parser    = @klass.new(load_part('/jp/available.txt'))
    expected  = nil
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }
  end

  def test_expires_on
    parser    = @klass.new(load_part('/jp/registered.txt'))
    expected  = Time.parse("2010-05-31")
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }

    parser    = @klass.new(load_part('/jp/available.txt'))
    expected  = nil
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }
  end

  def test_nameservers
    parser    = @klass.new(load_part('/jp/registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/jp/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end

class AnswerParserWhoisJprsJpNeJpTest < AnswerParserWhoisJprsJpTest

  def test_status
    parser    = @klass.new(load_part('/ne.jp/registered.txt'))
    expected  = "Connected (2010/09/30)"
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/ne.jp/available.txt'))
    expected  = nil
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    assert !@klass.new(load_part('/ne.jp/registered.txt')).available?
    assert  @klass.new(load_part('/ne.jp/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/ne.jp/registered.txt')).registered?
    assert !@klass.new(load_part('/ne.jp/available.txt')).registered?
  end


  def test_created_on
    parser    = @klass.new(load_part('/ne.jp/registered.txt'))
    expected  = Time.parse("2003-09-11")
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }

    parser    = @klass.new(load_part('/ne.jp/available.txt'))
    expected  = nil
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }
  end

  def test_updated_on
    parser    = @klass.new(load_part('/ne.jp/registered.txt'))
    # TODO: timezone
    # JST timezone is ignored by Time.parse
    expected  = Time.parse("2009-10-23 19:22:08 JST")
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }

    parser    = @klass.new(load_part('/ne.jp/available.txt'))
    expected  = nil
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }
  end

  def test_expires_on
    parser    = @klass.new(load_part('/ne.jp/registered.txt'))
    expected  = nil
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }

    parser    = @klass.new(load_part('/ne.jp/available.txt'))
    expected  = nil
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }
  end

  def test_nameservers
    parser    = @klass.new(load_part('/ne.jp/registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/ne.jp/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end
