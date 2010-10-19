require 'test_helper'
require 'whois/answer/parser/whois.nic.mu'

class AnswerParserWhoisNicMuTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicMu
    @host   = "whois.nic.mu"
  end

end

class AnswerParserWhoisNicMuKiTest < AnswerParserWhoisNicMuTest

  def test_status
    parser    = @klass.new(load_part('/ki/registered.txt'))
    expected  = :registered
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/ki/available.txt'))
    expected  = :available
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    parser    = @klass.new(load_part('/ki/registered.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('/ki/available.txt'))
    expected  = true
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }
  end

  def test_registered?
    parser    = @klass.new(load_part('/ki/registered.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('/ki/available.txt'))
    expected  = false
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }
  end


  def test_created_on
    assert_equal  Time.parse("2006-05-15"),
                  @klass.new(load_part('/ki/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/ki/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-09-30"),
                  @klass.new(load_part('/ki/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/ki/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2010-11-27"),
                  @klass.new(load_part('/ki/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/ki/available.txt')).expires_on
  end


  def test_nameservers
    parser    = @klass.new(load_part('/ki/registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/ki/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end

class AnswerParserWhoisNicMuMuTest < AnswerParserWhoisNicMuTest

  def test_status
    parser    = @klass.new(load_part('/mu/registered.txt'))
    expected  = :registered
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/mu/available.txt'))
    expected  = :available
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    parser    = @klass.new(load_part('/mu/registered.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('/mu/available.txt'))
    expected  = true
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }
  end

  def test_registered?
    parser    = @klass.new(load_part('/mu/registered.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('/mu/available.txt'))
    expected  = false
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }
  end


  def test_created_on
    assert_equal  Time.parse("2000-12-21"),
                  @klass.new(load_part('/mu/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/mu/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-12-04"),
                  @klass.new(load_part('/mu/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/mu/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2010-12-20"),
                  @klass.new(load_part('/mu/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/mu/available.txt')).expires_on
  end


  def test_nameservers
    parser    = @klass.new(load_part('/mu/registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/mu/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end
