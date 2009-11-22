require 'test_helper'
require 'whois/answer/parser/whois.nic.name.rb'

class AnswerParserWhoisNicNameTest < Test::Unit::TestCase

  TESTCASE_PATH = File.expand_path(File.dirname(__FILE__) + '/../../testcases/responses/whois.nic.name')

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicName
    @host   = "whois.nic.name"
  end


  def test_status
    assert_equal  :available,
                  @klass.new(load_part('/available.txt')).status
    assert_equal  :registered,
                  @klass.new(load_part('/registered.txt')).status
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
    assert_equal  nil,
                  @klass.new(load_part('/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  nil,
                  @klass.new(load_part('/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  nil,
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