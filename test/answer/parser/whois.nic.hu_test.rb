# coding: utf-8

require 'test_helper'
require 'whois/answer/parser/whois.nic.hu'

class AnswerParserWhoisNicHuTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicHu
    @host   = "whois.nic.hu"
  end


  def test_disclaimer
    expected = <<-EOS.strip
Rights restricted by copyright. Szerzõi jog fenntartva.
-Legal usage of this service requires that you agree to
abide by the rules and conditions set forth at
http://www.domain.hu/domain/English/domainsearch/feltetelek.html
-A szolgaltatas csak a
http://www.domain.hu/domain/domainsearch/feltetelek.html címen
elérhetõ feltételek elfogadása és betartása mellett
használható legálisan.
EOS
    assert_equal  expected,
                  @klass.new(load_part('/available.txt')).disclaimer
    assert_equal  expected,
                  @klass.new(load_part('/in_progress.txt')).disclaimer
    assert_equal  expected,
                  @klass.new(load_part('/registered.txt')).disclaimer
  end


  def test_domain
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).domain
    assert_equal  'ezitvps.hu',
                  @klass.new(load_part('/in_progress.txt')).domain
    assert_equal  'google.hu',
                  @klass.new(load_part('/registered.txt')).domain
  end

  def test_domain_id
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).domain_id
    assert_equal  nil,
                  @klass.new(load_part('/in_progress.txt')).domain_id
    assert_equal  '0000219547',
                  @klass.new(load_part('/registered.txt')).domain_id
  end


  def test_status
    assert_equal  :available,
                  @klass.new(load_part('/available.txt')).status
    assert_equal  :in_progress,
                  @klass.new(load_part('/in_progress.txt')).status
    assert_equal  :registered,
                  @klass.new(load_part('/registered.txt')).status
  end

  def test_available?
    assert  @klass.new(load_part('/available.txt')).available?
    assert !@klass.new(load_part('/in_progress.txt')).available?
    assert !@klass.new(load_part('/registered.txt')).available?
  end

  def test_registered?
    assert !@klass.new(load_part('/available.txt')).registered?
    assert !@klass.new(load_part('/in_progress.txt')).registered?
    assert  @klass.new(load_part('/registered.txt')).registered?
  end


  def test_created_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/in_progress.txt')).created_on
    assert_equal  Time.parse("2000-03-25 23:20:39"),
                  @klass.new(load_part('/registered.txt')).created_on
  end

  def test_updated_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/in_progress.txt')).updated_on
    assert_equal  Time.parse("2009-08-25 10:11:32"),
                  @klass.new(load_part('/registered.txt')).updated_on
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/in_progress.txt')).expires_on }
  end


  def test_registrar_with_registered
    registrar = @klass.new(load_part('/registered.txt')).registrar
    assert_instance_of Whois::Answer::Registrar, registrar
    assert_equal '1960108002', registrar.id
    assert_equal '3C Kft. (Registrar)', registrar.name
    assert_equal '3C Ltd.', registrar.organization
  end

  def test_registrar_with_unregistered
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).registrar
    assert_equal  nil,
                  @klass.new(load_part('/in_progress.txt')).registrar
  end


  def test_registrant_contact_with_registered
    parser      = @klass.new(load_part('/registered.txt'))
    expected    = parser.registrant_contact
    assert_instance_of Whois::Answer::Contact, expected
    assert_equal  expected, parser.registrant_contact
    assert_equal  expected, parser.instance_eval { @registrant_contact }
 end

  def test_registrant_contact_with_unregistered
    parser      = @klass.new(load_part('/available.txt'))
    expected    = nil
    assert_equal  expected, parser.registrant_contact
    assert_equal  expected, parser.instance_eval { @registrant_contact }

    parser      = @klass.new(load_part('/in_progress.txt'))
    expected    = nil
    assert_equal  expected, parser.registrant_contact
    assert_equal  expected, parser.instance_eval { @registrant }
  end

  def test_registrant_contact_as_company
    parser    = @klass.new(load_part('/property_registrant_as_company.txt'))
    result    = parser.registrant_contact

    assert_instance_of Whois::Answer::Contact,  result
    assert_equal Whois::Answer::Contact::TYPE_REGISTRANT, result.type
    assert_equal 'Google, Inc.',                result.name
    assert_equal 'Google, Inc.',                result.organization
    assert_equal 'Amphitheatre Pkwy 1600.',     result.address
    assert_equal 'CA-94043',                    result.zip
    assert_equal 'Mountain View',               result.city
    assert_equal 'US',                          result.country_code
    assert_equal '+1 650 253 0000',             result.phone
    assert_equal '+1 650 253 0001',             result.fax
  end

  def test_registrant_contact_as_private_person
    parser    = @klass.new(load_part('/property_registrant_as_private_person.txt'))
    result    = parser.registrant_contact

    assert_instance_of Whois::Answer::Contact,  result
    assert_equal Whois::Answer::Contact::TYPE_REGISTRANT, result.type
    assert_match /Buruzs/,                      result.name             # UTF-8 hack
    assert_equal nil,                           result.organization
    assert_equal nil,                           result.address
    assert_equal nil,                           result.zip
    assert_equal nil,                           result.city
    assert_equal nil,                           result.country_code
    assert_equal nil,                           result.phone
    assert_equal nil,                           result.fax
  end

  def test_registrant_contact_without_address
    parser    = @klass.new(load_part('/property_registrant_without_address.txt'))
    result    = parser.registrant_contact

    assert_equal nil, result.address
    assert_equal nil, result.zip
    assert_equal nil, result.city
    assert_equal nil, result.country_code
  end

  def test_admin_contact_with_registered
    result = @klass.new(load_part('/registered.txt')).admin_contact
    assert_instance_of Whois::Answer::Contact,    result
    assert_equal Whois::Answer::Contact::TYPE_ADMIN, result.type
    assert_equal '2000466366',                    result.id
    assert_equal '3C Kft. (Registrar)',           result.name
    assert_equal 'Konkoly Thege út 29-33.',       result.address
    assert_equal 'H-1121',                        result.zip
    assert_equal 'Budapest',                      result.city
    assert_equal 'HU',                            result.country_code
    assert_equal '+36 1 275 52 00',               result.phone
    assert_equal '+36 1 275 58 87',               result.fax
  end

  def test_admin_contact_with_unregistered
    parser      = @klass.new(load_part('/available.txt'))
    expected    = nil
    assert_equal  expected, parser.admin_contact
    assert_equal  expected, parser.instance_eval { @admin_contact }

    parser      = @klass.new(load_part('/in_progress.txt'))
    expected    = nil
    assert_equal  expected, parser.admin_contact
    assert_equal  expected, parser.instance_eval { @admin_contact }
  end

  def test_technical_contact_with_registered
    result = @klass.new(load_part('/registered.txt')).technical_contact
    assert_instance_of Whois::Answer::Contact,    result
    assert_equal Whois::Answer::Contact::TYPE_TECHNICAL, result.type
    assert_equal '2000578125',                    result.id
    assert_equal 'Markmonitor',                   result.name
    assert_equal 'Overland Road 10400, PMB155',   result.address
    assert_equal 'ID-83709',                      result.zip
    assert_equal 'Boise',                         result.city
    assert_equal 'US',                            result.country_code
    assert_equal '+ 1 208 389 5798',              result.phone
    assert_equal '+ 1 208 389 5771',              result.fax
    assert_equal 'ccops@markmonitor.com',         result.email
  end

  def test_technical_contact_with_unregistered
    parser      = @klass.new(load_part('/available.txt'))
    expected    = nil
    assert_equal  expected, parser.technical_contact
    assert_equal  expected, parser.instance_eval { @technical_contact }

    parser      = @klass.new(load_part('/in_progress.txt'))
    expected    = nil
    assert_equal  expected, parser.technical_contact
    assert_equal  expected, parser.instance_eval { @technical_contact }
  end


  def test_nameserver
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = %w( ns1.google.com ns4.google.com ns3.google.com ns2.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/in_progress.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end


  def test_zone_contact_with_registered
    zone_contact = @klass.new(load_part('/registered.txt')).zone_contact
    assert_instance_of Whois::Answer::Contact, zone_contact
    assert_equal '2000578125', zone_contact.id
    assert_equal 'Markmonitor', zone_contact.name
    assert_equal 'Overland Road 10400, PMB155', zone_contact.address
    assert_equal 'ID-83709', zone_contact.zip
    assert_equal 'Boise', zone_contact.city
    assert_equal 'US', zone_contact.country_code
    assert_equal '+ 1 208 389 5798', zone_contact.phone
    assert_equal '+ 1 208 389 5771', zone_contact.fax
    assert_equal 'ccops@markmonitor.com', zone_contact.email
  end

  def test_zone_contact_with_unregistered
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).zone_contact
    assert_equal  nil,
                  @klass.new(load_part('/in_progress.txt')).zone_contact
  end

  def test_registrar_contact_with_registered
    registrar_contact = @klass.new(load_part('/registered.txt')).registrar_contact
    assert_instance_of Whois::Answer::Contact, registrar_contact
    assert_equal '1960108002', registrar_contact.id
    assert_equal '3C Kft. (Registrar)', registrar_contact.name
    assert_equal '3C Ltd.', registrar_contact.organization
    assert_equal 'Konkoly Thege út 29-33.', registrar_contact.address
    assert_equal 'H-1121', registrar_contact.zip
    assert_equal 'Budapest', registrar_contact.city
    assert_equal 'HU', registrar_contact.country_code
    assert_equal '+36 1 275 52 00', registrar_contact.phone
    assert_equal '+36 1 275 58 87', registrar_contact.fax
  end

  def test_registrar_contact_with_unregistered
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).registrar_contact
    assert_equal  nil,
                  @klass.new(load_part('/in_progress.txt')).registrar_contact
  end

end