require 'test_helper'
require 'whois/answer/parser/whois.denic.de'

class AnswerParserWhoisDenicDeTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisDenicDe
    @host   = "whois.denic.de"
  end


  def test_disclaimer
    expected = <<-EOS.strip
The data in this record is provided by DENIC for informational purposes only. \
DENIC does not guarantee its accuracy and cannot, under any circumstances, \
be held liable in case the stored information would prove to be wrong, \
incomplete or not accurate in any sense. \
All the domain data that is visible in the whois service is protected by law. \
It is not permitted to use it for any purpose other than technical or \
administrative requirements associated with the operation of the Internet. \
It is explicitly forbidden to extract, copy and/or use or re-utilise in any \
form and by any means (electronically or not) the whole or a quantitatively \
or qualitatively substantial part of the contents of the whois database \
without prior and explicit written permission by DENIC. \
It is prohibited, in particular, to use it for transmission of unsolicited \
and/or commercial and/or advertising by phone, fax, e-mail or for any similar \
purposes. \
By maintaining the connection you assure that you have a legitimate interest \
in the data and that you will only use it for the stated purposes. You are \
aware that DENIC maintains the right to initiate legal proceedings against \
you in the event of any breach of this assurance and to bar you from using \
its whois service. \
The DENIC whois service on port 43 never discloses any information concerning \
the domain holder/administrative contact. Information concerning the domain \
holder/administrative contact can be obtained through use of our web-based \
whois service available at the DENIC website: \
http://www.denic.de/en/background/whois-service/webwhois.html
    EOS
    assert_equal  expected,
                  @klass.new(load_part('/registered.txt')).disclaimer
  end

  def test_disclaimer_with_available
    expected = <<-EOS.strip
The data in this record is provided by DENIC for informational purposes only. \
DENIC does not guarantee its accuracy and cannot, under any circumstances, \
be held liable in case the stored information would prove to be wrong, \
incomplete or not accurate in any sense. \
All the domain data that is visible in the whois service is protected by law. \
It is not permitted to use it for any purpose other than technical or \
administrative requirements associated with the operation of the Internet. \
It is explicitly forbidden to extract, copy and/or use or re-utilise in any \
form and by any means (electronically or not) the whole or a quantitatively \
or qualitatively substantial part of the contents of the whois database \
without prior and explicit written permission by DENIC. \
It is prohibited, in particular, to use it for transmission of unsolicited \
and/or commercial and/or advertising by phone, fax, e-mail or for any similar \
purposes. \
By maintaining the connection you assure that you have a legitimate interest \
in the data and that you will only use it for the stated purposes. You are \
aware that DENIC maintains the right to initiate legal proceedings against \
you in the event of any breach of this assurance and to bar you from using \
its whois service. \
The DENIC whois service on port 43 never discloses any information concerning \
the domain holder/administrative contact. Information concerning the domain \
holder/administrative contact can be obtained through use of our web-based \
whois service available at the DENIC website: \
http://www.denic.de/en/background/whois-service/webwhois.html
    EOS
    assert_equal  expected,
    @klass.new(load_part('/available.txt')).disclaimer
  end


  def test_domain
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).domain
    assert_equal  'google.de',
                  @klass.new(load_part('/registered.txt')).domain
  end

  def test_domain_id
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).domain_id }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).domain_id }
  end


  def test_status
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).status
    assert_equal  'connect',
                  @klass.new(load_part('/registered.txt')).status
  end

  def test_registered?
    assert  @klass.new(load_part('/registered.txt')).registered?
    assert !@klass.new(load_part('/available.txt')).registered?
  end

  def test_available?
    assert !@klass.new(load_part('/registered.txt')).available?
    assert  @klass.new(load_part('/available.txt')).available?
  end


  def test_created
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).created_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).created_on }
  end

  def test_updated_on
    assert_equal  Time.parse('2009-02-28 12:03:09 +0100'),
                  @klass.new(load_part('/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).updated_on
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).expires_on }
  end


  def test_registrar
    registrar = @klass.new(load_part('/registered.txt')).registrar
    assert_instance_of(Whois::Answer::Registrar, registrar)
    assert_equal(nil, registrar.id)
    assert_equal('Domain Billing', registrar.name)
    assert_equal('MarkMonitor', registrar.organization)
    assert_equal(nil, registrar.url)
  end

  def test_registrar_with_available
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).registrar
  end

  def test_registrant_contact_with_registered
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = nil
    assert_equal  expected, parser.registrant_contact
    assert_equal  expected, parser.instance_eval { @registrant_contact }
  end

  def test_registrant_contact_with_available
    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.registrant_contact
    assert_equal  expected, parser.instance_eval { @registrant_contact }
  end

  def test_admin_contact_with_registered
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = nil
    assert_equal  expected, parser.admin_contact
    assert_equal  expected, parser.instance_eval { @admin_contact }
  end

  def test_admin_contact_with_available
    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.admin_contact
    assert_equal  expected, parser.instance_eval { @admin_contact }
  end

  def test_technical_contact_with_registered
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = parser.technical_contact
    assert_equal  expected, parser.technical_contact
    assert_equal  expected, parser.instance_eval { @technical_contact }

    assert_instance_of Whois::Answer::Contact, expected
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

    assert_instance_of Whois::Answer::Contact, result
    assert_equal nil,                     result.id
    assert_equal 'Google Inc.',           result.name
    assert_equal nil,                     result.organization
    assert_equal ['Google Inc.', '1600 Amphitheatre Parkway'], result.address
    assert_equal 'Mountain View',         result.city
    assert_equal nil,                     result.state
    assert_equal '94043',                 result.zip
    assert_equal nil,                     result.country
    assert_equal 'US',                    result.country_code
    assert_equal '+1-6503300100',         result.phone
    assert_equal '+1-6506188571',         result.fax
    assert_equal 'dns-admin@google.com',  result.email
  end


  def test_nameservers
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = %w( ns1.google.com ns4.google.com ns3.google.com ns2.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

  def test_nameservers_with_ip
    parser    = @klass.new(load_part('/nameservers_with_ip.txt'))
    expected  = %w( ns1.prodns.de ns2.prodns.de ns3.prodns.de )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end


class AnswerParserWhoisDenicDe1100Test < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisDenicDe
    @host   = "whois.denic.de"
  end


  def test_disclaimer
    expected = <<-EOS.strip
All the domain data that is visible in the whois search is protected \
by law. It is not permitted to use it for any purpose other than \
technical or administrative requirements associated with the \
operation of the Internet or in order to contact the domain holder \
over legal problems. You are not permitted to save it electronically \
or in any other way without DENIC's express written permission. It \
is prohibited, in particular, to use it for advertising or any similar \
purpose. By maintaining the connection you assure that you have a legitimate \
interest in the data and that you will only use it for the stated \
purposes. You are aware that DENIC maintains the right to initiate \
legal proceedings against you in the event of any breach of this \
assurance and to bar you from using its whois query.
    EOS
    assert_equal  expected,
                  @klass.new(load_part('/1-10-0_registered.txt')).disclaimer
  end

  def test_disclaimer_with_available
    expected = <<-EOS.strip
All the domain data that is visible in the whois search is protected \
by law. It is not permitted to use it for any purpose other than \
technical or administrative requirements associated with the \
operation of the Internet or in order to contact the domain holder \
over legal problems. You are not permitted to save it electronically \
or in any other way without DENIC's express written permission. It \
is prohibited, in particular, to use it for advertising or any similar \
purpose. By maintaining the connection you assure that you have a legitimate \
interest in the data and that you will only use it for the stated \
purposes. You are aware that DENIC maintains the right to initiate \
legal proceedings against you in the event of any breach of this \
assurance and to bar you from using its whois query.
    EOS
    assert_equal  expected,
    @klass.new(load_part('/1-10-0_available.txt')).disclaimer
  end


  def test_domain
    assert_equal  nil,
                  @klass.new(load_part('/1-10-0_available.txt')).domain
    assert_equal  'google.de',
                  @klass.new(load_part('/1-10-0_registered.txt')).domain
  end

  def test_domain_id
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).domain_id }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).domain_id }
  end


  def test_status
    assert_equal  nil,
                  @klass.new(load_part('/1-10-0_available.txt')).status
    assert_equal  'connect',
                  @klass.new(load_part('/1-10-0_registered.txt')).status
  end

  def test_registered?
    assert  !@klass.new(load_part('/1-10-0_available.txt')).registered?
    assert  @klass.new(load_part('/1-10-0_registered.txt')).registered?
  end

  def test_available?
    assert  @klass.new(load_part('/1-10-0_available.txt')).available?
    assert  !@klass.new(load_part('/1-10-0_registered.txt')).available?
  end


  def test_created_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/1-10-0_registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/1-10-0_available.txt')).expires_on }
  end

  def test_updated_on
    assert_equal  Time.parse('2009-02-28 12:03:09 +01:00'),
                  @klass.new(load_part('/1-10-0_registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/1-10-0_available.txt')).updated_on
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/1-10-0_registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/1-10-0_available.txt')).expires_on }
  end


  def test_registrar_with_registered
    registrar = @klass.new(load_part('/1-10-0_registered.txt')).registrar
    assert_instance_of(Whois::Answer::Registrar, registrar)
    assert_equal(nil, registrar.id)
    assert_equal('Domain Billing', registrar.name)
    assert_equal('MarkMonitor', registrar.organization)
    assert_equal(nil, registrar.url)
  end

  def test_registrar_with_available
    assert_equal  nil,
                  @klass.new(load_part('/1-10-0_available.txt')).registrar
  end

  def test_registrant_contact_with_registered
    contact = @klass.new(load_part('/1-10-0_registered.txt')).registrant_contact
    assert_instance_of(Whois::Answer::Contact, contact)
    assert_equal(nil, contact.id)
    assert_equal('Google Inc.', contact.name)
    assert_equal(nil, contact.organization)
    assert_equal('1600 Amphitheatre Parkway', contact.address)
    assert_equal('Mountain View', contact.city)
    assert_equal(nil, contact.state)
    assert_equal('94043', contact.zip)
    assert_equal(nil, contact.country)
    assert_equal('US', contact.country_code)
    assert_equal(nil, contact.phone)
    assert_equal(nil, contact.fax)
    assert_equal(nil, contact.email)
  end

  def test_registrant_contact_with_available
    assert_equal  nil,
                  @klass.new(load_part('/1-10-0_available.txt')).registrant_contact
  end

  def test_admin_contact_with_registered
    contact = @klass.new(load_part('/1-10-0_registered.txt')).admin_contact
    assert_instance_of(Whois::Answer::Contact, contact)
    assert_equal(nil, contact.id)
    assert_equal('Lena Tangermann', contact.name)
    assert_equal('Google Germany GmbH', contact.organization)
    assert_equal('ABC-Strasse 19', contact.address)
    assert_equal('Hamburg', contact.city)
    assert_equal(nil, contact.state)
    assert_equal('20354', contact.zip)
    assert_equal(nil, contact.country)
    assert_equal('DE', contact.country_code)
    assert_equal(nil, contact.phone)
    assert_equal(nil, contact.fax)
    assert_equal(nil, contact.email)
  end

  def test_admin_contact_with_available
    assert_equal  nil,
                  @klass.new(load_part('/1-10-0_available.txt')).admin_contact
  end

  def test_technical_contact_with_registered
    contact = @klass.new(load_part('/1-10-0_registered.txt')).technical_contact
    assert_instance_of(Whois::Answer::Contact, contact)
    assert_equal(nil, contact.id)
    assert_equal('Google Inc.', contact.name)
    assert_equal(nil, contact.organization)
    assert_equal(['Google Inc.', '1600 Amphitheatre Parkway'], contact.address)
    assert_equal('Mountain View', contact.city)
    assert_equal(nil, contact.state)
    assert_equal('94043', contact.zip)
    assert_equal(nil, contact.country)
    assert_equal('US', contact.country_code)
    assert_equal('+1-6503300100', contact.phone)
    assert_equal('+1-6506188571', contact.fax)
    assert_equal('dns-admin@google.com', contact.email)
  end

  def test_technical_contact_with_available
    assert_equal  nil,
                  @klass.new(load_part('/1-10-0_available.txt')).technical_contact
  end


  def test_nameservers
    parser    = @klass.new(load_part('/1-10-0_registered.txt'))
    expected  = %w( ns1.google.com ns4.google.com ns3.google.com ns2.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/1-10-0_available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end
