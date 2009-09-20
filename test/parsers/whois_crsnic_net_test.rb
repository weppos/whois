require 'test_helper'
require 'whois/answer/parsers/whois.crsnic.net'

class WhoisCrsnicNetTest < Test::Unit::TestCase

  TESTCASE_PATH = File.expand_path(File.dirname(__FILE__) + '/../testcases/responses/whois.crsnic.net')

  def setup
    @klass  = Whois::Answer::Parsers::WhoisCrsnicNet
    @server = Whois::Server.factory(:tld, ".net", "whois.crsnic.net")
    @answer = Whois::Answer
  end


  def test_disclaimer
    expected = <<-EOS.strip
TERMS OF USE: You are not authorized to access or query our Whois \
database through the use of electronic processes that are high-volume and \
automated except as reasonably necessary to register domain names or \
modify existing registrations; the Data in VeriSign Global Registry \
Services' ("VeriSign") Whois database is provided by VeriSign for \
information purposes only, and to assist persons in obtaining information \
about or related to a domain name registration record. VeriSign does not \
guarantee its accuracy. By submitting a Whois query, you agree to abide \
by the following terms of use: You agree that you may use this Data only \
for lawful purposes and that under no circumstances will you use this Data \
to: (1) allow, enable, or otherwise support the transmission of mass \
unsolicited, commercial advertising or solicitations via e-mail, telephone, \
or facsimile; or (2) enable high volume, automated, electronic processes \
that apply to VeriSign (or its computer systems). The compilation, \
repackaging, dissemination or other use of this Data is expressly \
prohibited without the prior written consent of VeriSign. You agree not to \
use electronic processes that are automated and high-volume to access or \
query the Whois database except as reasonably necessary to register \
domain names or modify existing registrations. VeriSign reserves the right \
to restrict your access to the Whois database in its sole discretion to ensure \
operational stability.  VeriSign may restrict or terminate your access to the \
Whois database for failure to abide by these terms of use. VeriSign \
reserves the right to modify these terms at any time.
EOS
    assert_equal  expected,
                  @klass.new(load_answer('/registered.txt')).disclaimer
  end

  def test_disclaimer_with_available
    expected = <<-EOS.strip
TERMS OF USE: You are not authorized to access or query our Whois \
database through the use of electronic processes that are high-volume and \
automated except as reasonably necessary to register domain names or \
modify existing registrations; the Data in VeriSign Global Registry \
Services' ("VeriSign") Whois database is provided by VeriSign for \
information purposes only, and to assist persons in obtaining information \
about or related to a domain name registration record. VeriSign does not \
guarantee its accuracy. By submitting a Whois query, you agree to abide \
by the following terms of use: You agree that you may use this Data only \
for lawful purposes and that under no circumstances will you use this Data \
to: (1) allow, enable, or otherwise support the transmission of mass \
unsolicited, commercial advertising or solicitations via e-mail, telephone, \
or facsimile; or (2) enable high volume, automated, electronic processes \
that apply to VeriSign (or its computer systems). The compilation, \
repackaging, dissemination or other use of this Data is expressly \
prohibited without the prior written consent of VeriSign. You agree not to \
use electronic processes that are automated and high-volume to access or \
query the Whois database except as reasonably necessary to register \
domain names or modify existing registrations. VeriSign reserves the right \
to restrict your access to the Whois database in its sole discretion to ensure \
operational stability.  VeriSign may restrict or terminate your access to the \
Whois database for failure to abide by these terms of use. VeriSign \
reserves the right to modify these terms at any time.
EOS
    assert_equal  expected,
                  @klass.new(load_answer('/available.txt')).disclaimer
  end


  def test_domain
    assert_equal  "googlelkjhgfdfghjklkjhgf.net",
                  @klass.new(load_answer('/available.txt')).domain
    assert_equal  "google.net",
                  @klass.new(load_answer('/registered.txt')).domain
  end

  def test_domain_id
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).domain_id
    assert_equal  nil,
                  @klass.new(load_answer('/registered.txt')).domain_id
  end


  def test_referral_whois
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).referral_whois
    assert_equal  "whois.markmonitor.com",
                  @klass.new(load_answer('/registered.txt')).referral_whois
  end

  def test_referral_url
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).referral_url
    assert_equal  "http://www.markmonitor.com",
                  @klass.new(load_answer('/registered.txt')).referral_url
  end


  def test_status
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).status
    assert_equal  ["clientDeleteProhibited", "clientTransferProhibited", "clientUpdateProhibited"],
                  @klass.new(load_answer('/registered.txt')).status
  end

  def test_available?
    assert !@klass.new(load_answer('/registered.txt')).available?
    assert  @klass.new(load_answer('/available.txt')).available?
  end

  def test_registered?
    assert !@klass.new(load_answer('/available.txt')).registered?
    assert  @klass.new(load_answer('/registered.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("1999-03-15 00:00:00"),
                  @klass.new(load_answer('/registered.txt')).created_on
  end

  def test_created_on_with_available
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-02-10 00:00:00"),
                  @klass.new(load_answer('/registered.txt')).updated_on
  end

  def test_updated_on_with_available
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2010-03-15 00:00:00"),
                  @klass.new(load_answer('/registered.txt')).expires_on
  end

  def test_expires_on_with_available
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).expires_on
  end


  def test_registrar
    assert_equal  nil,
                  @klass.new(load_answer('/registrar.txt')).registrar
  end

  def test_registrar_with_available
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).registrar
  end


  protected

    def load_answer(path)
      new_answer(@server, File.read(TESTCASE_PATH + path))
    end

    def new_answer(server, content)
      @answer.new(server, [[content, server.host]])
    end

end