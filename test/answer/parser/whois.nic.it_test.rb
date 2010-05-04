require 'test_helper'
require 'whois/answer/parser/whois.nic.it'

class AnswerParserWhoisNicItTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicIt
    @host   = "whois.nic.it"
  end


  def test_disclaimer
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = "Please note that the following result could be a subgroup of the data contained in the database. Additional information can be visualized at: http://www.nic.it/cgi-bin/Whois/whois.cgi"
    assert_equal  expected, parser.disclaimer
    assert_equal  expected, parser.instance_eval { @disclaimer }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.disclaimer
    assert_equal  expected, parser.instance_eval { @disclaimer }
  end


  def test_domain
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = "google.it"
    assert_equal  expected, parser.domain
    assert_equal  expected, parser.instance_eval { @domain }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = "google.it"
    assert_equal  expected, parser.domain
    assert_equal  expected, parser.instance_eval { @domain }
  end

  def test_domain_id
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).domain_id }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).domain_id }
  end


  def test_status
    parser    = @klass.new(load_part('/property_status_active.txt'))
    expected  = :active
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/property_status_available.txt'))
    expected  = :available
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    assert !@klass.new(load_part('/registered.txt')).available?
    assert  @klass.new(load_part('/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/registered.txt')).registered?
    assert !@klass.new(load_part('/available.txt')).registered?
  end


  # NOTE: Unfortunately, the whois.nic.it response doesn't include TimeZone
  def test_created_on
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = Time.parse("1999-12-10 00:00:00")
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }
  end

  # NOTE: Unfortunately, the whois.nic.it response doesn't include TimeZone
  def test_updated_on
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = Time.parse("2008-11-27 16:47:22")
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }
  end

  # NOTE: Unfortunately, the whois.nic.it response doesn't include TimeZone
  def test_expires_on
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = Time.parse("2009-11-27 00:00:00")
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }
  end


  def test_registrar
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = parser.registrar
    assert_equal  expected, parser.registrar
    assert_equal  expected, parser.instance_eval { @registrar }

    assert_instance_of Whois::Answer::Registrar, expected
    assert_equal "REGISTER-MNT", expected.id
  end

  def test_registrar_with_available
    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.registrar
    assert_equal  expected, parser.instance_eval { @registrar }
  end

  def test_registrar
    parser    = @klass.new(load_part('/registered.txt'))
    result    = parser.registrar

    assert_instance_of Whois::Answer::Registrar,  result
    assert_equal "REGISTER-MNT",                  result.id
    assert_equal "REGISTER-MNT",                  result.name
    assert_equal "Register.it s.p.a.",            result.organization
  end


  def test_registrant_contact_with_registered
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = parser.registrant_contact
    assert_equal  expected, parser.registrant_contact
    assert_equal  expected, parser.instance_eval { @registrant_contact }

    assert_instance_of Whois::Answer::Contact, expected
    assert_equal "GOOG175-ITNIC", expected.id
  end

  def test_registrant_contact_with_available
    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.registrant_contact
    assert_equal  expected, parser.instance_eval { @registrant_contact }
  end

  def test_registrant_contact
    parser    = @klass.new(load_part('/property_registrant_contact.txt'))
    result    = parser.registrant_contact

    assert_instance_of Whois::Answer::Contact,      result
    assert_equal "HTML1-ITNIC",                     result.id
    assert_equal "HTML.it srl",                     result.name
    assert_equal "HTML.it srl",                     result.organization
    assert_equal "Viale Alessandrino, 595",         result.address
    assert_equal "Roma",                            result.city
    assert_equal "00172",                           result.zip
    assert_equal nil,                               result.country
    assert_equal "IT",                              result.country_code
    assert_equal Time.parse("2007-03-01 10:28:08"), result.created_on
    assert_equal Time.parse("2007-03-01 10:28:08"), result.updated_on
  end

  def test_admin_contact_with_registered
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = parser.admin_contact
    assert_equal  expected, parser.admin_contact
    assert_equal  expected, parser.instance_eval { @admin_contact }

    assert_instance_of Whois::Answer::Contact, expected
    assert_equal "TT4277-ITNIC", expected.id
  end

  def test_admin_contact_with_available
    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.admin_contact
    assert_equal  expected, parser.instance_eval { @admin_contact }
  end

  def test_admin_contact
    parser    = @klass.new(load_part('/property_admin_contact.txt'))
    result    = parser.admin_contact

    assert_instance_of Whois::Answer::Contact,      result
    assert_equal "TT4277-ITNIC",                    result.id
    assert_equal "Tsao Tu",                         result.name
    assert_equal "Tu Tsao",                         result.organization
    assert_equal "30 Herbert Street",               result.address
    assert_equal "Dublin",                          result.city
    assert_equal "2",                               result.zip
    assert_equal nil,                               result.country
    assert_equal "IE",                              result.country_code
    assert_equal Time.parse("2008-11-27 16:47:22"), result.created_on
    assert_equal Time.parse("2008-11-27 16:47:22"), result.updated_on
  end

  def test_technical_contact_with_registered
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = parser.technical_contact
    assert_equal  expected, parser.technical_contact
    assert_equal  expected, parser.instance_eval { @technical_contact }

    assert_instance_of Whois::Answer::Contact, expected
    assert_equal "TS7016-ITNIC", expected.id
  end

  def test_technical_contact_with_available
    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.technical_contact
    assert_equal  expected, parser.instance_eval { @technical_contact }
  end

  def test_technical_contact
    parser    = @klass.new(load_part('/property_technical_contact.txt'))
    result    = parser.technical_contact

    assert_instance_of Whois::Answer::Contact,  result
    assert_equal "TS7016-ITNIC",                result.id
    assert_equal "Technical Services",          result.name
    assert_equal nil,                           result.organization
    assert_equal nil,                           result.address
    assert_equal nil,                           result.city
    assert_equal nil,                           result.zip
    assert_equal nil,                           result.country
    assert_equal nil,                           result.country_code
    assert_equal nil,                           result.created_on
    assert_equal nil,                           result.updated_on
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