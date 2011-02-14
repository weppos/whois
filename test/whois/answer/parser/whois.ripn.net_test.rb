require 'test_helper'
require 'whois/answer/parser/whois.ripn.net'

class AnswerParserWhoisRipnNetTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisRipnNet
    @host   = "whois.ripn.net"
  end

end

class AnswerParserWhoisRipnNetRuTest < AnswerParserWhoisRipnNetTest

  def setup
    super
    @suffix = "ru"
  end


  def test_status
    parser    = @klass.new(load_part('registered.txt'))
    expected  = %w( REGISTERED DELEGATED VERIFIED )
    assert_equal_and_cached expected, parser, :status

    parser    = @klass.new(load_part('available.txt'))
    expected  = %w()
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
    expected  = Time.parse("2004-03-04")
    assert_equal_and_cached expected, parser, :created_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :created_on
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('available.txt')).updated_on }
  end

  def test_expires_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2011-03-05")
    assert_equal_and_cached expected, parser, :expires_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :expires_on
  end


  def test_registrar
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Whois::Answer::Registrar.new(:id => "RUCENTER-REG-RIPN")
    assert_equal_and_cached expected, parser, :registrar

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :registrar
  end


  def test_admin_contact
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Whois::Answer::Contact.new(
      :type         => Whois::Answer::Contact::TYPE_ADMIN,
      :organization => 'Google Inc',
      :phone        => '+1 650 330 0100',
      :fax          => '+1 650 618 8571',
      :email        => 'dns-admin@google.com'
    )
    assert_equal_and_cached expected, parser, :admin_contact
  end


  def test_nameservers
    parser    = @klass.new(load_part('registered.txt'))
    expected  = %w( ns1.google.com. ns2.google.com. ns3.google.com. ns4.google.com. ).map do |ns|
      Whois::Answer::Nameserver.new(ns)
    end
    assert_equal_and_cached expected, parser, :nameservers

    parser    = @klass.new(load_part('available.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers
  end

  def test_nameservers_with_ip
    parser    = @klass.new(load_part('property_nameservers_with_ip.txt'))
    names     = %w( ns.masterhost.ru. ns1.masterhost.ru. ns2.masterhost.ru. )
    ips       = %w( 217.16.20.30      217.16.16.30       217.16.22.30       )
    expected  = Hash[hosts.zip(ips)].map do |name, ip|
      Whois::Answer::Nameserver.new(name, ip)
    end
    assert_equal_and_cached expected, parser, :nameservers
  end

end


class AnswerParserWhoisRipnNetSuTest < AnswerParserWhoisRipnNetTest

  def setup
    super
    @suffix = "su"
  end


  def test_status
    parser    = @klass.new(load_part('registered.txt'))
    expected  = %w( REGISTERED DELEGATED UNVERIFIED )
    assert_equal_and_cached expected, parser, :status

    parser    = @klass.new(load_part('available.txt'))
    expected  = %w()
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
    expected  = Time.parse("2005-10-16")
    assert_equal_and_cached expected, parser, :created_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :created_on
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('available.txt')).updated_on }
  end

  def test_expires_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2010-10-16")
    assert_equal_and_cached expected, parser, :expires_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :expires_on
  end


  def test_registrar
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Whois::Answer::Registrar.new(:id => "RUCENTER-REG-FID")
    assert_equal_and_cached expected, parser, :registrar

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :registrar
  end


  def test_admin_contact
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Whois::Answer::Contact.new(
      :type         => Whois::Answer::Contact::TYPE_ADMIN,
      :name         => 'Private Person',
      :phone        => '+7 495 9681807',
      :fax          => '+7 495 9681807',
      :email        => 'cis@cis.su'
    )
    assert_equal_and_cached expected, parser, :admin_contact
  end


  def test_nameservers
    parser    = @klass.new(load_part('registered.txt'))
    expected  = %w( ns1073.hostgator.com. ns1074.hostgator.com. ).map do |ns|
      Whois::Answer::Nameserver.new(ns)
    end
    assert_equal_and_cached expected, parser, :nameservers

    parser    = @klass.new(load_part('available.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers
  end

end
