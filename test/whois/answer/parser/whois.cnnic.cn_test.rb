require 'test_helper'
require 'whois/answer/parser/whois.cnnic.cn'

class AnswerParserWhoisCnnicCnTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisCnnicCn
    @host   = "whois.cnnic.cn"
  end
  
  def test_domain
    parser    = @klass.new(load_part('registered.txt'))
    expected  = "google.cn"
    assert_equal_and_cached expected, parser, :domain
  end


  def test_status
    assert_equal  ["clientDeleteProhibited", "serverDeleteProhibited", "clientUpdateProhibited",
                   "serverUpdateProhibited", "clientTransferProhibited", "serverTransferProhibited"],
                  @klass.new(load_part('registered.txt')).status
    assert_equal  [],
                  @klass.new(load_part('available.txt')).status
  end

  def test_available?
    parser    = @klass.new(load_part('registered.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :available?
    
    parser    = @klass.new(load_part('registered_status_ok.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :available?
    
    parser    = @klass.new(load_part('reserved.txt'))
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
    
    parser    = @klass.new(load_part('registered_status_ok.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :registered?
    
    parser    = @klass.new(load_part('reserved.txt'))
    expected  = true
    assert_equal_and_cached expected, parser, :registered?

    parser    = @klass.new(load_part('available.txt'))
    expected  = false
    assert_equal_and_cached expected, parser, :registered?
  end


  def test_created_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2003-03-17 12:20:00")
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
    expected  = Time.parse("2012-03-17 12:48:00")
    assert_equal_and_cached expected, parser, :expires_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :expires_on
  end
  
  def test_registrar_with_registered
    parser    = @klass.new(load_part('registered.txt'))
    expected  = parser.registrar
    assert_equal_and_cached expected, parser, :registrar

    assert_instance_of Whois::Answer::Registrar,  expected
    assert_equal "MarkMonitor, Inc.",             expected.id
    assert_equal "MarkMonitor, Inc.",             expected.name
  end

  def test_registrar_with_available
    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :registrar
  end
  
  def test_registrant_contact_with_registered
    parser    = @klass.new(load_part('registered.txt'))
    expected  = parser.registrant_contact
    assert_equal_and_cached expected, parser, :registrant_contact

    assert_instance_of Whois::Answer::Contact,            expected
    assert_equal "Google Ireland Holdings",               expected.organization
    assert_equal Whois::Answer::Contact::TYPE_REGISTRANT, expected.type
    assert_equal "Domain Admin",                          expected.name
  end

  def test_registrant_contact_with_available
    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    
    assert_equal_and_cached expected, parser, :registrant_contact
  end
  
  def test_admin_contact_with_registered
    parser    = @klass.new(load_part('registered.txt'))
    expected  = parser.admin_contact
    assert_equal_and_cached expected, parser, :admin_contact

    assert_instance_of Whois::Answer::Contact,            expected
    assert_equal Whois::Answer::Contact::TYPE_ADMIN,      expected.type
    assert_equal "dns-admin@google.com",                  expected.email
  end

  def test_admin_contact_with_available
    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    
    assert_equal_and_cached expected, parser, :admin_contact
  end
  
  def test_technical_contact
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('available.txt')).updated_on }
  end


  def test_nameservers
    parser    = @klass.new(load_part('registered.txt'))
    expected  = %w( ns1.google.cn ns2.google.com ns1.google.com ns3.google.com ns4.google.com ).map { |ns| nameserver(ns) }
    assert_equal_and_cached expected, parser, :nameservers

    parser    = @klass.new(load_part('available.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers
  end

end
