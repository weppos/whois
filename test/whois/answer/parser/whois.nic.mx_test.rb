require 'test_helper'
require 'whois/answer/parser/whois.nic.mx'

class AnswerParserWhoisNicMxTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicMx
    @host   = "whois.nic.mx"
  end


  def test_status
    parser    = @klass.new(load_part('registered.txt'))
    expected  = :registered
    assert_equal_and_cached expected, parser, :status

    parser    = @klass.new(load_part('available.txt'))
    expected  = :available
    assert_equal_and_cached expected, parser, :status
  end

  def test_available?
    parser    = @klass.new(load_part('registered.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :available?

    parser    = @klass.new(load_part('available.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :available?
  end

  def test_registered?
    parser    = @klass.new(load_part('registered.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :registered?

    parser    = @klass.new(load_part('available.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :registered?
  end


  def test_created_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2003-02-24")
    assert_equal_and_cached expected, parser, :created_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :created_on
  end

  # def test_updated_on
  #   parser    = @klass.new(load_part('registered.txt'))
  #   expected  = Time.parse("2010-02-23")
  #   assert_equal_and_cached expected, parser, :updated_on
  # 
  #   parser    = @klass.new(load_part('available.txt'))
  #   expected  = nil
  #   assert_equal_and_cached expected, parser, :updated_on
  # end

  def test_expires_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2011-02-23")
    assert_equal_and_cached expected, parser, :expires_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :expires_on
  end


  def test_nameservers
    parser    = @klass.new(load_part('registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com ).map { |ns| nameserver(ns) }
    assert_equal_and_cached expected, parser, :nameservers

    parser    = @klass.new(load_part('available.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers
  end

  def test_nameservers_with_ip
    parser    = @klass.new(load_part('property_nameservers_with_ip.txt'))
    names     = %w( dns1.mpsnet.net.mx dns2.mpsnet.net.mx )
    ipv4s     = %w( 200.4.48.15        200.4.48.16        )
    expected  = Hash[names.zip(ipv4s)].map { |name, ipv4| nameserver(name, ipv4) }

    assert_equal_and_cached expected, parser, :nameservers
  end

end
