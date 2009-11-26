require 'test_helper'
require 'whois/answer/parser/whois.nic.hu.rb'

class AnswerParserWhoisNicHuTest < Test::Unit::TestCase

  TESTCASE_PATH = File.expand_path(File.dirname(__FILE__) + '/../../testcases/responses/whois.nic.hu')

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicHu
    @host   = "whois.nic.hu"
  end

    def test_disclaimer_with_available
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

  def test_domain
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).domain
    assert_equal  'ezitvps.hu',
                  @klass.new(load_part('/in_progress.txt')).domain
    assert_equal  'google.hu',
                  @klass.new(load_part('/registered.txt')).domain
  end

  def test_id
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).domain_id
    assert_equal  nil,
                  @klass.new(load_part('/in_progress.txt')).domain_id
    assert_equal  '0000219547',
                  @klass.new(load_part('/registered.txt')).domain_id
  end

  def test_registrant_with_registered
    registrant = @klass.new(load_part('/registered.txt')).registrant
    assert_instance_of Whois::Answer::Contact, registrant
    assert_equal 'Google, Inc.', registrant.name
    assert_equal 'Google, Inc.', registrant.organization
    assert_equal 'Amphitheatre Pkwy 1600.', registrant.address
    assert_equal 'CA-94043', registrant.zip
    assert_equal 'Mountain View', registrant.city
    assert_equal 'US', registrant.country_code
    assert_equal '+1 650 253 0000', registrant.phone
    assert_equal '+1 650 253 0001', registrant.fax
    
  end

  def test_registrant_with_unregistered
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).registrant
    assert_equal  nil,
                  @klass.new(load_part('/in_progress.txt')).registrant
  end

  def test_nameserver
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).nameservers
    assert_equal  nil,
                  @klass.new(load_part('/in_progress.txt')).nameservers
    assert_equal  %w(ns1.google.com ns2.google.com ns3.google.com ns4.google.com),
                  @klass.new(load_part('/registered.txt')).nameservers.sort
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

  def test_admin_with_registered
    admin = @klass.new(load_part('/registered.txt')).admin
    assert_instance_of Whois::Answer::Contact, admin
    assert_equal '2000466366', admin.id
    assert_equal '3C Kft. (Registrar)', admin.name
    assert_equal 'Konkoly Thege út 29-33.', admin.address
    assert_equal 'H-1121', admin.zip
    assert_equal 'Budapest', admin.city
    assert_equal 'HU', admin.country_code
    assert_equal '+36 1 275 52 00', admin.phone
    assert_equal '+36 1 275 58 87', admin.fax
  end

  def test_admin_with_unregistered
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).admin
    assert_equal  nil,
                  @klass.new(load_part('/in_progress.txt')).admin
  end

  def test_technical_with_registered
    technical = @klass.new(load_part('/registered.txt')).technical
    assert_instance_of Whois::Answer::Contact, technical
    assert_equal '2000578125', technical.id
    assert_equal 'Markmonitor', technical.name
    assert_equal 'Overland Road 10400, PMB155', technical.address
    assert_equal 'ID-83709', technical.zip
    assert_equal 'Boise', technical.city
    assert_equal 'US', technical.country_code
    assert_equal '+ 1 208 389 5798', technical.phone
    assert_equal '+ 1 208 389 5771', technical.fax
    assert_equal 'ccops@markmonitor.com', technical.email
  end

  def test_technical_with_unregistered
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).technical
    assert_equal  nil,
                  @klass.new(load_part('/in_progress.txt')).technical
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

  protected

    def load_part(path)
      part(File.read(TESTCASE_PATH + path), @host)
    end

    def part(*args)
      Whois::Answer::Part.new(*args)
    end

end