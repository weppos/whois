require 'test_helper'
require 'whois/answer/parser/whois.publicinterestregistry.net'

class AnswerParserWhoisPublicinterestregistryNetTest < Test::Unit::TestCase

  TESTCASE_PATH = File.expand_path(File.dirname(__FILE__) + '/../../testcases/responses/whois.publicinterestregistry.net')

  def setup
    @klass  = Whois::Answer::Parser::WhoisPublicinterestregistryNet
    @host   = "whois.publicinterestregistry.net"
  end


  def test_disclaimer
    expected = <<-EOS.strip
NOTICE: Access to .ORG WHOIS information is provided to assist persons in \
determining the contents of a domain name registration record in the Public Interest Registry \
registry database. The data in this record is provided by Public Interest Registry \
for informational purposes only, and Public Interest Registry does not guarantee its \
accuracy.  This service is intended only for query-based access.  You agree \
that you will use this data only for lawful purposes and that, under no \
circumstances will you use this data to: (a) allow, enable, or otherwise \
support the transmission by e-mail, telephone, or facsimile of mass \
unsolicited, commercial advertising or solicitations to entities other than \
the data recipient's own existing customers; or (b) enable high volume, \
automated, electronic processes that send queries or data to the systems of \
Registry Operator or any ICANN-Accredited Registrar, except as reasonably \
necessary to register domain names or modify existing registrations.  All \
rights reserved. Public Interest Registry reserves the right to modify these terms at any \
time. By submitting this query, you agree to abide by this policy.
    EOS
    assert_equal  expected,
                  @klass.new(load_part('/registered.txt')).disclaimer
  end

  def test_disclaimer_with_available
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).disclaimer
  end


  def test_domain
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).domain
    assert_equal  "google.org",
                  @klass.new(load_part('/registered.txt')).domain
  end

  def test_domain_id
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).domain_id
    assert_equal  "D2244233-LROR",
                  @klass.new(load_part('/registered.txt')).domain_id
  end


  def test_status
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).status
    assert_equal  ["CLIENT DELETE PROHIBITED", "CLIENT TRANSFER PROHIBITED", "CLIENT UPDATE PROHIBITED"],
                  @klass.new(load_part('/registered.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/registered.txt')).available?
    assert  @klass.new(load_part('/available.txt')).available?
  end

  def test_registered?
    assert !@klass.new(load_part('/available.txt')).registered?
    assert  @klass.new(load_part('/registered.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("1998-10-21 04:00:00 UTC"),
                  @klass.new(load_part('/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-03-04 12:07:19 UTC"),
                  @klass.new(load_part('/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2012-10-20 04:00:00 UTC"),
                  @klass.new(load_part('/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).expires_on
  end


  def test_registrar
    registrar = @klass.new(load_part('/registered.txt')).registrar
    assert_instance_of Whois::Answer::Registrar, registrar
    assert_equal "R37-LROR", registrar.id
    assert_equal "MarkMonitor Inc.", registrar.name
    assert_equal nil, registrar.organization
  end

  def test_registrar_with_available
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).registrar
  end


  def test_registrant
    contact = @klass.new(load_part('/registered.txt')).registrant
    assert_instance_of Whois::Answer::Contact, contact
    assert_equal "mmr-32097", contact.id
    assert_equal "DNS Admin", contact.name
    assert_equal "Google Inc.", contact.organization
    assert_equal "1600 Amphitheatre Parkway", contact.address
    assert_equal "Mountain View", contact.city
    assert_equal "CA", contact.state
    assert_equal "94043", contact.zip
    assert_equal nil, contact.country
    assert_equal "US", contact.country_code
    assert_equal "+1.6506234000", contact.phone
    assert_equal "+1.6506188571", contact.fax
    assert_equal "dns-admin@google.com", contact.email
  end

  def test_registrant_with_available
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).registrant
  end


  def test_admin
    contact = @klass.new(load_part('/registered.txt')).admin
    assert_instance_of Whois::Answer::Contact, contact
    assert_equal "mmr-32097", contact.id
    assert_equal "DNS Admin", contact.name
    assert_equal "Google Inc.", contact.organization
    assert_equal "1600 Amphitheatre Parkway", contact.address
    assert_equal "Mountain View", contact.city
    assert_equal "CA", contact.state
    assert_equal "94043", contact.zip
    assert_equal nil, contact.country
    assert_equal "US", contact.country_code
    assert_equal "+1.6506234000", contact.phone
    assert_equal "+1.6506188571", contact.fax
    assert_equal "dns-admin@google.com", contact.email
  end

  def test_admin_with_available
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).admin
  end


  def test_technical
    contact = @klass.new(load_part('/registered.txt')).technical
    assert_instance_of Whois::Answer::Contact, contact
    assert_equal "mmr-32097", contact.id
    assert_equal "DNS Admin", contact.name
    assert_equal "Google Inc.", contact.organization
    assert_equal "1600 Amphitheatre Parkway", contact.address
    assert_equal "Mountain View", contact.city
    assert_equal "CA", contact.state
    assert_equal "94043", contact.zip
    assert_equal nil, contact.country
    assert_equal "US", contact.country_code
    assert_equal "+1.6506234000", contact.phone
    assert_equal "+1.6506188571", contact.fax
    assert_equal "dns-admin@google.com", contact.email
  end

  def test_technical_with_available
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).technical
  end


  def test_nameservers
    assert_equal  %w(ns2.google.com ns1.google.com ns3.google.com ns4.google.com),
                  @klass.new(load_part('/registered.txt')).nameservers
  end

  def test_nameservers_with_available
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).nameservers
  end


  protected

    def load_part(path)
      part(File.read(TESTCASE_PATH + path), @host)
    end

    def part(*args)
      Whois::Answer::Part.new(*args)
    end

end