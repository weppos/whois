require 'test_helper'
require 'whois/answer/parser/whois.afilias.info.rb'

class AnswerParserWhoisAfiliasInfoTest < Test::Unit::TestCase

  TESTCASE_PATH = File.expand_path(File.dirname(__FILE__) + '/../../testcases/responses/whois.afilias.info')

  def setup
    @klass  = Whois::Answer::Parser::WhoisAfiliasInfo
    @host   = "whois.afilias.info"
  end


  def test_status
    assert_equal  ["CLIENT DELETE PROHIBITED", "CLIENT TRANSFER PROHIBITED", "CLIENT UPDATE PROHIBITED"],
                  @klass.new(load_part('/registered.txt')).status
    assert_equal  [],
                  @klass.new(load_part('/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/registered.txt')).available?
    assert  @klass.new(load_part('/available.txt')).available?
  end

  def test_registered?
    assert !@klass.new(load_part('/available.txt')).registered?
    assert  @klass.new(load_part('/registered.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("2001-07-31 23:57:50 UTC"),
                  @klass.new(load_part('/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-03-05 22:39:19 UTC"),
                  @klass.new(load_part('/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2010-07-31 23:57:50 UTC"),
                  @klass.new(load_part('/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).expires_on
  end


  protected

    def load_part(path)
      part(File.read(TESTCASE_PATH + path), @host)
    end

    def part(*args)
      Whois::Answer::Part.new(*args)
    end

end