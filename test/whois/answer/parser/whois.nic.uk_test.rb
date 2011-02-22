require 'test_helper'
require 'whois/answer/parser/whois.nic.uk'

class AnswerParserWhoisNicUkTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicUk
    @host   = "whois.nic.uk"
  end


  def test_status
    parser    = @klass.new(load_part('property_status_registered.txt'))
    expected  = :registered
    assert_equal_and_cached expected, parser, :status

    parser    = @klass.new(load_part('property_status_missing.txt'))
    expected  = :available
    assert_equal_and_cached expected, parser, :status

    parser    = @klass.new(load_part('property_status_suspended.txt'))
    # NEWSTATUS
    expected  = :registered
    assert_equal_and_cached expected, parser, :status

    parser    = @klass.new(load_part('property_status_processing_registration.txt'))
    expected  = :registered
    assert_equal_and_cached expected, parser, :status

    parser    = @klass.new(load_part('property_status_processing_renewal.txt'))
    expected  = :registered
    assert_equal_and_cached expected, parser, :status
  end

  def test_available?
    parser    = @klass.new(load_part('property_status_registered.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :available?

    parser    = @klass.new(load_part('property_status_missing.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :available?

    parser    = @klass.new(load_part('property_status_suspended.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :available?

    parser    = @klass.new(load_part('property_status_processing_registration.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :available?

    parser    = @klass.new(load_part('property_status_processing_renewal.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :available?
  end

  def test_registered?
    parser    = @klass.new(load_part('property_status_registered.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :registered?

    parser    = @klass.new(load_part('property_status_missing.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :registered?

    parser    = @klass.new(load_part('property_status_suspended.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :registered?

    parser    = @klass.new(load_part('property_status_processing_registration.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :registered?

    parser    = @klass.new(load_part('property_status_processing_renewal.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :registered?
  end

  def test_valid?
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :valid?

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :valid?

    parser    = @klass.new(load_part('status_invalid.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :valid?
  end

  def test_invalid?
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :invalid?

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :invalid?

    parser    = @klass.new(load_part('status_invalid.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :invalid?
  end


  def test_created_on
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = Time.parse("1999-02-14")
    assert_equal_and_cached expected, parser, :created_on

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :created_on
  end

  def test_updated_on
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = Time.parse("2009-08-13")
    assert_equal_and_cached expected, parser, :updated_on

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :updated_on
  end

  def test_expires_on
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = Time.parse("2011-02-14")
    assert_equal_and_cached expected, parser, :expires_on

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :expires_on
  end


  def test_nameservers
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com ).map { |ns| nameserver(ns) }
    assert_equal_and_cached expected, parser, :nameservers

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers
  end

  def test_nameservers_with_suspended
    parser    = @klass.new(load_part('property_status_suspended.txt'))
    expected  = %w( )
    assert_equal_and_cached expected, parser, :nameservers
  end

  def test_nameservers_with_ip
    parser    = @klass.new(load_part('property_nameservers_with_ip.txt'))
    names     = %w( ns0.netbenefit.co.uk ns1.netbenefit.co.uk )
    ipv4s     = %w( 212.53.64.30         212.53.77.30         )
    expected  = names.zip(ipv4s).map { |name, ipv4| nameserver(name, ipv4) }
    assert_equal_and_cached expected, parser, :nameservers
  end

  def test_registrar
    parser    = @klass.new(load_part('/registered.txt'))
    result    = parser.registrar

    assert_instance_of Whois::Answer::Registrar,  result
    assert_equal "MARKMONITOR",                   result.id
    assert_equal "Markmonitor",                   result.name
    assert_equal "Markmonitor Inc.",              result.organization
    assert_equal "http://www.markmonitor.com",    result.url
  end

end
