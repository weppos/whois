require 'test_helper'
require 'whois/answer/parser/whois.nic.cc'

class AnswerParserWhoisNicCcTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicCc
    @host   = "whois.nic.cc"
  end


  def test_disclaimer
    expected = <<-EOS.strip
TERMS OF USE: You are not authorized to access or query our Whois \
database through the use of electronic processes that are high-volume and \
automated except as reasonably necessary to register domain names or \
modify existing registrations; the Data in VeriSign's ("VeriSign") Whois \
database is provided by VeriSign for information purposes only, and to \
assist persons in obtaining information about or related to a domain name \
registration record. VeriSign does not guarantee its accuracy. \
By submitting a Whois query, you agree to abide by the following terms of \
use: You agree that you may use this Data only for lawful purposes and that \
under no circumstances will you use this Data to: (1) allow, enable, or \
otherwise support the transmission of mass unsolicited, commercial \
advertising or solicitations via e-mail, telephone, or facsimile; or \
(2) enable high volume, automated, electronic processes that apply to \
VeriSign (or its computer systems). The compilation, repackaging, \
dissemination or other use of this Data is expressly prohibited without \
the prior written consent of VeriSign. You agree not to use electronic \
processes that are automated and high-volume to access or query the \
Whois database except as reasonably necessary to register domain names \
or modify existing registrations. VeriSign reserves the right to restrict \
your access to the Whois database in its sole discretion to ensure \
operational stability.  VeriSign may restrict or terminate your access to the \
Whois database for failure to abide by these terms of use. VeriSign \
reserves the right to modify these terms at any time. 
EOS
    assert_equal  expected,
                  @klass.new(load_part('/registered.txt')).disclaimer
    assert_equal  expected,
                  @klass.new(load_part('/available.txt')).disclaimer
  end


  def test_domain
    assert_equal  "google.cc",
                  @klass.new(load_part('/registered.txt')).domain
    assert_equal  "u34jedzcq.cc",
                  @klass.new(load_part('/available.txt')).domain
  end

  def test_domain_id
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).domain_id }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).domain_id }
  end


  def test_referral_whois
    assert_equal  "whois.markmonitor.com",
                  @klass.new(load_part('/registered.txt')).referral_whois
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).referral_whois
  end

  def test_referral_url
    assert_equal  "http://www.markmonitor.com",
                  @klass.new(load_part('/registered.txt')).referral_url
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).referral_url
  end


  def test_status
    assert_equal  ["CLIENT-XFER-PROHIBITED", "CLIENT-UPDATE-PROHIBITED", "CLIENT-DELETE-PROHIBITED"],
                  @klass.new(load_part('/registered.txt')).status
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/registered.txt')).available?
    assert  @klass.new(load_part('/available.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/registered.txt')).registered?
    assert !@klass.new(load_part('/available.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("1999-06-07"),
                  @klass.new(load_part('/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-05-06"),
                  @klass.new(load_part('/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2010-06-07"),
                  @klass.new(load_part('/registered.txt')).expires_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).expires_on
  end


  def test_registrar
    assert_equal  nil,
                  @klass.new(load_part('/registered.txt')).registrar
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).registrar
  end

end