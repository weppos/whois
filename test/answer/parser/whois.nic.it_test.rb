require 'test_helper'
require 'whois/answer/parser/whois.nic.it.rb'

class AnswerParserWhoisNicItTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicIt
    @host   = "whois.nic.it"
  end


  def test_disclaimer
    assert_equal  "Please note that the following result could be a subgroup of the data contained in the database. Additional information can be visualized at: http://www.nic.it/cgi-bin/Whois/whois.cgi",
                  @klass.new(load_part('/registered.txt')).disclaimer
  end

  def test_disclaimer_with_available
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).disclaimer
  end


  def test_domain
    assert_equal  "google.it",
                  @klass.new(load_part('/available.txt')).domain
    assert_equal  "google.it",
                  @klass.new(load_part('/registered.txt')).domain
  end

  def test_domain_id
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).domain_id }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).domain_id }
  end


  def test_status
    assert_equal  :available,
                  @klass.new(load_part('/status_available.txt')).status
    assert_equal  :active,
                  @klass.new(load_part('/status_active.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/registered.txt')).available?
    assert  @klass.new(load_part('/available.txt')).available?
  end

  def test_registered?
    assert !@klass.new(load_part('/available.txt')).registered?
    assert  @klass.new(load_part('/registered.txt')).registered?
  end


  # NOTE: Unfortunately, the whois.nic.it response doesn't include TimeZone
  def test_created_on
    assert_equal  Time.parse("1999-12-10 00:00:00"),
                  @klass.new(load_part('/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).created_on
  end

  # NOTE: Unfortunately, the whois.nic.it response doesn't include TimeZone
  def test_updated_on
    assert_equal  Time.parse("2008-11-27 16:47:22"),
                  @klass.new(load_part('/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).updated_on
  end

  # NOTE: Unfortunately, the whois.nic.it response doesn't include TimeZone
  def test_expires_on
    assert_equal  Time.parse("2009-11-27 00:00:00"),
                  @klass.new(load_part('/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).expires_on
  end


  def test_registrar
    registrar = @klass.new(load_part('/registered.txt')).registrar
    assert_instance_of Whois::Answer::Registrar, registrar
    assert_equal "REGISTER-MNT", registrar.id
    assert_equal "REGISTER-MNT", registrar.name
    assert_equal "Register.it s.p.a.", registrar.organization
  end

  def test_registrar_with_available
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).registrar
  end


  def test_contact
    contact = @klass.new(load_part('/contact.txt')).registrant
    assert_instance_of Whois::Answer::Contact, contact
    assert_equal "HTML1-ITNIC", contact.id
    assert_equal "HTML.it srl", contact.name
    assert_equal "HTML.it srl", contact.organization
    assert_equal "Viale Alessandrino, 595", contact.address
    assert_equal "Roma", contact.city
    assert_equal "00172", contact.zip
    assert_equal nil, contact.country
    assert_equal "IT", contact.country_code
    assert_equal Time.parse("2007-03-01 10:28:08"), contact.created_on
    assert_equal Time.parse("2007-03-01 10:28:08"), contact.updated_on
  end

  def test_registrant
    contact = @klass.new(load_part('/registered.txt')).registrant
    assert_instance_of Whois::Answer::Contact, contact
    assert_equal "GOOG175-ITNIC", contact.id
    assert_equal "Google Ireland Holdings", contact.name
    assert_equal nil, contact.organization
    assert_equal "30 Herbert Street", contact.address
    assert_equal "Dublin", contact.city
    assert_equal "2", contact.zip
    assert_equal nil, contact.country
    assert_equal "IE", contact.country_code
    assert_equal Time.parse("2008-11-27 16:47:22"), contact.created_on
    assert_equal Time.parse("2008-11-27 16:47:22"), contact.updated_on
  end

  def test_registrant_with_available
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).registrant
  end

  def test_admin
    contact = @klass.new(load_part('/registered.txt')).admin
    assert_instance_of Whois::Answer::Contact, contact
    assert_equal "TT4277-ITNIC", contact.id
    assert_equal "Tsao Tu", contact.name
    assert_equal "Tu Tsao", contact.organization
    assert_equal "30 Herbert Street", contact.address
    assert_equal "Dublin", contact.city
    assert_equal "2", contact.zip
    assert_equal nil, contact.country
    assert_equal "IE", contact.country_code
    assert_equal Time.parse("2008-11-27 16:47:22"), contact.created_on
    assert_equal Time.parse("2008-11-27 16:47:22"), contact.updated_on
  end

  def test_admin_with_available
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).admin
  end

  def test_technical
    contact = @klass.new(load_part('/registered.txt')).technical
    assert_instance_of Whois::Answer::Contact, contact
    assert_equal "TS7016-ITNIC", contact.id
    assert_equal "Technical Services", contact.name
    assert_equal nil, contact.organization
    assert_equal nil, contact.address
    assert_equal nil, contact.city
    assert_equal nil, contact.zip
    assert_equal nil, contact.country
    assert_equal nil, contact.country_code
    assert_equal nil, contact.created_on
    assert_equal nil, contact.updated_on
  end

  def test_technical_with_available
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).technical
  end


  def test_nameservers
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = %w( ns1.google.com ns4.google.com ns2.google.com ns3.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end


  def test_changed_question_check_self
    parser = @klass.new(load_part('/registered.txt'))
    assert !parser.changed?(parser)
  end

  def test_changed_question_check_internals
    parser = @klass.new(load_part('/registered.txt'))
    assert parser.changed?(@klass.new(load_part('/available.txt')))
  end

  def test_changed_question_check_self_with_available
    parser = @klass.new(part(<<-RESPONSE, @host))
Domain:             google.it
Status:             AVAILABLE
    RESPONSE

    assert !parser.changed?(parser)
  end

  def test_changed_question_check_internals_with_available
    parser = @klass.new(part(<<-RESPONSE, @host))
Domain:             google.it
Status:             AVAILABLE
    RESPONSE

    assert  parser.changed?(@klass.new(part(<<-RESPONSE, @host)))
Domain:             weppos.it
Status:             AVAILABLE
    RESPONSE
    assert !parser.changed?(@klass.new(part(<<-RESPONSE, @host)))
Domain:             google.it
Status:             AVAILABLE
    RESPONSE
  end

  def test_unchanged_question_check_self
    parser = @klass.new(load_part('/registered.txt'))
    assert parser.unchanged?(parser)
  end

  def test_unchanged_question_check_internals
    parser = @klass.new(load_part('/registered.txt'))
    assert parser.unchanged?(@klass.new(load_part('/registered.txt')))
  end

  def test_unchanged_question_check_self_with_available
    parser = @klass.new(part(<<-RESPONSE, @host))
Domain:             google.it
Status:             AVAILABLE
    RESPONSE

    assert  parser.unchanged?(parser)
  end

  def test_unchanged_question_check_internals_with_available
    parser = @klass.new(part(<<-RESPONSE, @host))
Domain:             google.it
Status:             AVAILABLE
    RESPONSE

    assert  parser.unchanged?(@klass.new(part(<<-RESPONSE, @host)))
Domain:             google.it
Status:             AVAILABLE
    RESPONSE
    assert !parser.unchanged?(@klass.new(part(<<-RESPONSE, @host)))
Domain:             weppos.it
Status:             AVAILABLE
    RESPONSE
  end

end