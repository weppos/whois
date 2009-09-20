require 'test_helper'
require 'whois/answer/parsers/whois.denic.de'

class WhoisDenicDeTest < Test::Unit::TestCase

  TESTCASE_PATH = File.expand_path(File.dirname(__FILE__) + '/../testcases/responses/de')

  def setup
    @class  = Whois::Answer::Parsers::WhoisDenicDe
    @server = Whois::Server.factory(:tld, ".de", "whois.denic.de")
    @answer = Whois::Answer
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
    assert_equal(expected, @class.new(load_answer('/available.txt')).disclaimer)
    assert_equal(expected, @class.new(load_answer('/registered.txt')).disclaimer)
  end

  def test_registered
    assert(!@class.new(load_answer('/available.txt')).registered?)
    assert(@class.new(load_answer('/registered.txt')).registered?)
  end

  def test_available
    assert(@class.new(load_answer('/available.txt')).available?)
    assert(!@class.new(load_answer('/registered.txt')).available?)
  end

  def test_status
    assert_equal(nil, @class.new(load_answer('/available.txt')).status)
    assert_equal('connect', @class.new(load_answer('/registered.txt')).status)
  end

  def test_domain
    assert_equal(nil, @class.new(load_answer('/available.txt')).domain)
    assert_equal('google.de', @class.new(load_answer('/registered.txt')).domain)
  end

  def test_created_on
    assert_equal(nil, @class.new(load_answer('/available.txt')).created_on)
  end

  def test_expires_on
    assert_equal(nil, @class.new(load_answer('/available.txt')).expires_on)
  end

  def test_updated_on
    assert_equal(nil, @class.new(load_answer('/available.txt')).updated_on)
    assert_equal(Time.parse('2009-02-28T12:03:09+01:00'), @class.new(load_answer('/registered.txt')).updated_on)
  end

  def test_registrar
    registrar = @class.new(load_answer('/registered.txt')).registrar
    assert_instance_of(Whois::Answer::Registrar, registrar)
    assert_equal(nil, registrar.id)
    assert_equal('Domain Billing', registrar.name)
    assert_equal('MarkMonitor', registrar.organization)
    assert_equal(nil, registrar.url)
  end

  def test_registrar_for_avalable_domain
    assert_equal(nil, @class.new(load_answer('/available.txt')).registrar)
  end

  def test_registrant
    contact = @class.new(load_answer('/registered.txt')).registrant
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

  def test_registrant_for_avalable_domain
    assert_equal(nil, @class.new(load_answer('/available.txt')).registrant)
  end

  def test_admin
    contact = @class.new(load_answer('/registered.txt')).admin
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

  def test_admin_for_avalable_domain
    assert_equal(nil, @class.new(load_answer('/available.txt')).admin)
  end

  def test_technical
    contact = @class.new(load_answer('/registered.txt')).technical
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

  def test_technical_for_avalable_domain
    assert_equal  nil,
                  @class.new(load_answer('/available.txt')).technical
  end

  def test_nameservers
    assert_equal  %w(ns1.google.com ns4.google.com ns3.google.com ns2.google.com),
                  @class.new(load_answer('/registered.txt')).nameservers
  end

  def test_nameservers_for_available_domain
    assert_equal  nil,
                  @class.new(load_answer('/available.txt')).nameservers
  end

  
  protected

    def load_answer(path)
      new_answer(@server, File.read(TESTCASE_PATH + path))
    end

    def new_answer(server, content)
      @answer.new(server, [[content, server.host]])
    end

end
