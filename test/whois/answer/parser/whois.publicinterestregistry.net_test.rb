require 'test_helper'
require 'whois/answer/parser/whois.publicinterestregistry.net'

class AnswerParserWhoisPublicinterestregistryNetTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisPublicinterestregistryNet
    @host   = "whois.publicinterestregistry.net"
  end


  def test_disclaimer
    parser    = @klass.new(load_part('registered.txt'))
    expected  = <<-EOS.strip
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
    assert_equal_and_cached expected, parser, :disclaimer

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :disclaimer
  end


  def test_domain
    parser    = @klass.new(load_part('registered.txt'))
    expected  = "google.org"
    assert_equal_and_cached expected, parser, :domain

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :domain
  end

  def test_domain_id
    parser    = @klass.new(load_part('registered.txt'))
    expected  = "D2244233-LROR"
    assert_equal_and_cached expected, parser, :domain_id

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :domain_id
  end


  def test_status
    parser    = @klass.new(load_part('registered.txt'))
    expected  = ["CLIENT DELETE PROHIBITED", "CLIENT TRANSFER PROHIBITED", "CLIENT UPDATE PROHIBITED"]
    assert_equal_and_cached expected, parser, :status

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
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
    expected  = Time.parse("1998-10-21 04:00:00 UTC")
    assert_equal_and_cached expected, parser, :created_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :created_on
  end

  def test_updated_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2009-03-04 12:07:19 UTC")
    assert_equal_and_cached expected, parser, :updated_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :updated_on
  end

  def test_expires_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2012-10-20 04:00:00 UTC")
    assert_equal_and_cached expected, parser, :expires_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :expires_on
  end


  def test_registrar_with_registered
    parser      = @klass.new(load_part('registered.txt'))
    expected    = parser.registrar
    assert_equal_and_cached expected, parser, :registrar

    assert_instance_of Whois::Answer::Registrar, expected
    assert_equal "R37-LROR", expected.id
  end

  def test_registrar_with_available
    parser      = @klass.new(load_part('available.txt'))
    expected    = nil
    assert_equal_and_cached expected, parser, :registrar
  end

  def test_registrar
    parser    = @klass.new(load_part('registered.txt'))
    result    = parser.registrar

    assert_instance_of Whois::Answer::Registrar,      result
    assert_equal "R37-LROR",                          result.id
    assert_equal "MarkMonitor Inc.",                  result.name
    assert_equal nil,                                 result.organization
  end


  def test_registrant_contact_with_registered
    parser      = @klass.new(load_part('registered.txt'))
    expected    = parser.registrant_contact
    assert_equal_and_cached expected, parser, :registrant_contact

    assert_instance_of Whois::Answer::Contact, expected
    assert_equal "mmr-32097", expected.id
  end

  def test_registrant_contact_with_available
    parser      = @klass.new(load_part('available.txt'))
    expected    = nil
    assert_equal_and_cached expected, parser, :registrant_contact
  end

  def test_registrant_contact
    parser    = @klass.new(load_part('registered.txt'))
    result    = parser.registrant_contact

    assert_instance_of Whois::Answer::Contact,      result
    assert_equal "mmr-32097",                       result.id
    assert_equal Whois::Answer::Contact::TYPE_REGISTRANT, result.type
    assert_equal "DNS Admin",                       result.name
    assert_equal "Google Inc.",                     result.organization
    assert_equal "1600 Amphitheatre Parkway",       result.address
    assert_equal "Mountain View",                   result.city
    assert_equal "CA",                              result.state
    assert_equal "94043",                           result.zip
    assert_equal nil,                               result.country
    assert_equal "US",                              result.country_code
    assert_equal "+1.6506234000",                   result.phone
    assert_equal "+1.6506188571",                   result.fax
    assert_equal "dns-admin@google.com",            result.email
  end

  def test_admin_contact_with_registered
    parser      = @klass.new(load_part('registered.txt'))
    expected    = parser.admin_contact
    assert_equal_and_cached expected, parser, :admin_contact

    assert_instance_of Whois::Answer::Contact, expected
    assert_equal "mmr-32097", expected.id
  end

  def test_admin_contact_with_available
    parser      = @klass.new(load_part('available.txt'))
    expected    = nil
    assert_equal_and_cached expected, parser, :admin_contact
  end

  def test_admin_contact
    parser    = @klass.new(load_part('registered.txt'))
    result    = parser.admin_contact

    assert_instance_of Whois::Answer::Contact,      result
    assert_equal "mmr-32097",                       result.id
    assert_equal Whois::Answer::Contact::TYPE_ADMIN, result.type
    assert_equal "DNS Admin",                       result.name
    assert_equal "Google Inc.",                     result.organization
    assert_equal "1600 Amphitheatre Parkway",       result.address
    assert_equal "Mountain View",                   result.city
    assert_equal "CA",                              result.state
    assert_equal "94043",                           result.zip
    assert_equal nil,                               result.country
    assert_equal "US",                              result.country_code
    assert_equal "+1.6506234000",                   result.phone
    assert_equal "+1.6506188571",                   result.fax
    assert_equal "dns-admin@google.com",            result.email
  end

  def test_technical_contact_with_registered
    parser      = @klass.new(load_part('registered.txt'))
    expected    = parser.technical_contact
    assert_equal_and_cached expected, parser, :technical_contact

    assert_instance_of Whois::Answer::Contact, expected
    assert_equal "mmr-32097", expected.id
  end

  def test_technical_contact_with_available
    parser      = @klass.new(load_part('available.txt'))
    expected    = nil
    assert_equal_and_cached expected, parser, :technical_contact
  end

  def test_technical_contact
    parser    = @klass.new(load_part('registered.txt'))
    result    = parser.technical_contact

    assert_instance_of Whois::Answer::Contact,      result
    assert_equal "mmr-32097",                       result.id
    assert_equal Whois::Answer::Contact::TYPE_TECHNICAL, result.type
    assert_equal "DNS Admin",                       result.name
    assert_equal "Google Inc.",                     result.organization
    assert_equal "1600 Amphitheatre Parkway",       result.address
    assert_equal "Mountain View",                   result.city
    assert_equal "CA",                              result.state
    assert_equal "94043",                           result.zip
    assert_equal nil,                               result.country
    assert_equal "US",                              result.country_code
    assert_equal "+1.6506234000",                   result.phone
    assert_equal "+1.6506188571",                   result.fax
    assert_equal "dns-admin@google.com",            result.email
  end


  def test_nameservers
    parser    = @klass.new(load_part('registered.txt'))
    expected  = %w( ns2.google.com ns1.google.com ns3.google.com ns4.google.com ).map { |ns| nameserver(ns) }
    assert_equal_and_cached expected, parser, :nameservers

    parser    = @klass.new(load_part('available.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers
  end


  def test_throttle_question
    parser = @klass.new(load_part('response_throttle.txt'))
    assert parser.throttle?
  end

end