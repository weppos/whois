require 'test_helper'
require 'whois/answer/parser/whois.nic.ve'

class AnswerParserWhoisNicVeTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicVe
    @host   = "whois.nic.ve"
  end


  def test_status
    parser    = @klass.new(load_part('property_status_activo.txt'))
    expected  = :registered
    assert_equal_and_cached expected, parser, :status

    parser    = @klass.new(load_part('property_status_missing.txt'))
    expected  = :available
    assert_equal_and_cached expected, parser, :status

    parser    = @klass.new(load_part('property_status_suspendido.txt'))
    expected  = :suspended
    assert_equal_and_cached expected, parser, :status
  end

  def test_available?
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :available?

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :available?

    parser    = @klass.new(load_part('status_suspended.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :available?
  end

  def test_registered?
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :registered?

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :registered?

    parser    = @klass.new(load_part('status_suspended.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :registered?
  end


  def test_created_on
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = Time.parse("2010-10-27 12:23:43")
    assert_equal_and_cached expected, parser, :created_on

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :created_on
  end

  def test_updated_on
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :updated_on

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :updated_on

    parser    = @klass.new(load_part('property_updated_on.txt'))
    expected  = Time.parse("2005-11-17 21:16:31")
    assert_equal_and_cached expected, parser, :updated_on
  end

  def test_updated_on_blank
    parser    = @klass.new(load_part('property_updated_on_blank.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :updated_on
  end

  def test_expires_on
    # parser    = @klass.new(load_part('status_registered.txt'))
    # expected  = Time.parse("2011-10-27 12:23:43")
    # assert_equal_and_cached expected, parser, :expires_on

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :expires_on
  end

  def test_expires_on_missing
    parser    = @klass.new(load_part('property_expires_on_missing.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :expires_on
  end


  def test_nameservers
    # parser    = @klass.new(load_part('status_registered.txt'))
    # expected  = %w( avalon.ula.ve azmodan.ula.ve )
    # assert_equal_and_cached expected, parser, :nameservers

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers

    parser    = @klass.new(load_part('property_nameservers.txt'))
    expected  = %w( avalon.ula.ve azmodan.ula.ve ).map { |ns| nameserver(ns) }
    assert_equal_and_cached expected, parser, :nameservers
  end

  def test_nameservers_missing
    parser    = @klass.new(load_part('property_nameservers_missing.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers
  end

end
