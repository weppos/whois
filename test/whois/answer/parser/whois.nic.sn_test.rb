require 'test_helper'
require 'whois/answer/parser/whois.nic.sn'

class AnswerParserWhoisNicSnTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicSn
    @host   = "whois.nic.sn"
  end


  def test_disclaimer
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('status_registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('status_available.txt')).updated_on }
  end


  def test_domain
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = "google.sn"
    assert_equal_and_cached expected, parser, :domain

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = "u34jedzcq.sn"
    assert_equal_and_cached expected, parser, :domain
  end

  def test_domain_id
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('status_registered.txt')).domain_id }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('status_available.txt')).domain_id }
  end


  def test_referral_whois
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('status_registered.txt')).referral_whois }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('status_available.txt')).referral_whois }
  end

  def test_referral_url
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('status_registered.txt')).referral_url }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('status_available.txt')).referral_url }
  end


  def test_status
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = :registered
    assert_equal_and_cached expected, parser, :status

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = :available
    assert_equal_and_cached expected, parser, :status
  end

  def test_available?
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :available?

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :available?
  end

  def test_registered?
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :registered?

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :registered?
  end


  def test_created_on
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = Time.parse("2008-05-08 17:59:38.43")
    assert_equal_and_cached expected, parser, :created_on

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :created_on
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('status_registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('status_available.txt')).updated_on }
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('status_registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('status_available.txt')).expires_on }
  end


  def test_registrar
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = Whois::Answer::Registrar.new(:id => "registry", :name => "registry")
    assert_equal_and_cached expected, parser, :registrar

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :registrar
  end


  def test_registrant_contact
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = Whois::Answer::Contact.new(:id => "C4-SN", :name => "C4-SN")
    assert_equal_and_cached expected, parser, :registrant_contact

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :registrant_contact
  end

  def test_admin_contact
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = Whois::Answer::Contact.new(:id => "C5-SN", :name => "C5-SN")
    assert_equal_and_cached expected, parser, :admin_contact

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :admin_contact
  end

  def test_technical_contact
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = Whois::Answer::Contact.new(:id => "C6-SN", :name => "C6-SN")
    assert_equal_and_cached expected, parser, :technical_contact

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :technical_contact
  end


  def test_nameservers
    parser    = @klass.new(load_part('status_registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com ).map { |ns| nameserver(ns) }
    assert_equal_and_cached expected, parser, :nameservers

    parser    = @klass.new(load_part('status_available.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers
  end

end
