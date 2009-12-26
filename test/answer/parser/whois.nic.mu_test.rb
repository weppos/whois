require 'test_helper'
require 'whois/answer/parser/whois.nic.mu.rb'

class AnswerParserWhoisNicMuTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicMu
    @host   = "whois.nic.mu"
  end

end

class AnswerParserWhoisNicMuKiTest < AnswerParserWhoisNicMuTest

  def test_status
    assert_equal  :registered,
                  @klass.new(load_part('/ki/registered.txt')).status
    assert_equal  :available,
                  @klass.new(load_part('/ki/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/ki/registered.txt')).available?
    assert  @klass.new(load_part('/ki/available.txt')).available?
  end

  def test_registered?
    assert !@klass.new(load_part('/ki/available.txt')).registered?
    assert  @klass.new(load_part('/ki/registered.txt')).registered?
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

end

class AnswerParserWhoisNicMuMuTest < AnswerParserWhoisNicMuTest

  def test_status
    assert_equal  :registered,
                  @klass.new(load_part('/mu/registered.txt')).status
    assert_equal  :available,
                  @klass.new(load_part('/mu/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/mu/registered.txt')).available?
    assert  @klass.new(load_part('/mu/available.txt')).available?
  end

  def test_registered?
    assert !@klass.new(load_part('/mu/available.txt')).registered?
    assert  @klass.new(load_part('/mu/registered.txt')).registered?
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

end
