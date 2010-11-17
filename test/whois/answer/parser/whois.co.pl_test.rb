require 'test_helper'
require 'whois/answer/parser/whois.co.pl'

class AnswerParserWhoisCoPlTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisCoPl
    @host   = "whois.co.pl"
  end


  def test_disclaimer
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).disclaimer }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).disclaimer }
  end


  def test_domain
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = "coco.co.pl"
    assert_equal  expected, parser.domain
    assert_equal  expected, parser.instance_eval { @domain }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.domain
    assert_equal  expected, parser.instance_eval { @domain }
  end

  def test_domain_id
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).domain_id }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).domain_id }
  end


  def test_referral_whois
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).referral_whois }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).referral_whois }
  end

  def test_referral_url
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).referral_url }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).referral_url }
  end


  def test_status
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = :registered
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = :available
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = true
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }
  end

  def test_registered?
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = false
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }
  end


  def test_created_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).created_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).created_on }
  end

  def test_updated_on
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = Time.parse("2010-06-23 09:41:50")
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).expires_on }
  end


  def test_registrar
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).registrar }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).registrar }
  end


  def test_registrant_contact
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).registrant_contact }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).registrant_contact }
  end

  def test_admin_contact
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).admin_contact }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).admin_contact }
  end

  def test_technical_contact
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).technical_contact }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).technical_contact }
  end


  def test_nameservers
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = %w( ns1.co.pl ns2.co.pl )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end
