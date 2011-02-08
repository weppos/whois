require 'test_helper'
require 'whois/answer/parser/jobswhois.verisign-grs.com'

class AnswerParserJobswhoisVerisignGrsComTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::JobswhoisVerisignGrsCom
    @host   = "jobswhois.verisign-grs.com"
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

    parser    = @klass.new(load_part('registered.txt'))
    assert_equal_and_cached expected, parser, :disclaimer

    parser    = @klass.new(load_part('available.txt'))
    assert_equal_and_cached expected, parser, :disclaimer
  end


  def test_domain
    parser    = @klass.new(load_part('registered.txt'))
    expected  = "goto.jobs"
    assert_equal_and_cached expected, parser, :domain

    parser    = @klass.new(load_part('available.txt'))
    expected  = "u34jedzcq.jobs"
    assert_equal_and_cached expected, parser, :domain
  end

  def test_domain_id
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('registered.txt')).domain_id }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('available.txt')).domain_id }
  end


  def test_referral_whois
    parser    = @klass.new(load_part('registered.txt'))
    expected  = "whois.encirca.com"
    assert_equal_and_cached expected, parser, :referral_whois

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :referral_whois
  end

  def test_referral_url_with_registered
    parser    = @klass.new(load_part('registered.txt'))
    expected  = "http://www.encirca.com"
    assert_equal_and_cached expected, parser, :referral_url
  end

  def test_referral_url_with_available
    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :referral_url
  end


  def test_status
    parser    = @klass.new(load_part('registered.txt'))
    expected  = "ACTIVE"
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
    expected  = Time.parse("2006-02-21")
    assert_equal_and_cached expected, parser, :created_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :created_on
  end

  def test_updated_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2009-02-20")
    assert_equal_and_cached expected, parser, :updated_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :updated_on
  end

  def test_expires_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2010-02-21")
    assert_equal_and_cached expected, parser, :expires_on

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :expires_on
  end


  def test_registrar_with_registered
    parser    = @klass.new(load_part('registered.txt'))
    expected  = parser.registrar
    assert_equal_and_cached expected, parser, :registrar

    assert_instance_of Whois::Answer::Registrar, expected
    assert_equal "ENCIRCA, INC", expected.name
  end

  def test_registrar_with_available
    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal_and_cached expected, parser, :registrar
  end

  def test_registrar
    parser    = @klass.new(load_part('property_registrar.txt'))
    result    = parser.registrar

    assert_instance_of Whois::Answer::Registrar,  result
    assert_equal nil,                             result.id
    assert_equal "ENCIRCA, INC",                  result.name
    assert_equal "ENCIRCA, INC",                  result.organization
    assert_equal "http://www.encirca.com",        result.url
  end


  def test_nameservers
    parser    = @klass.new(load_part('registered.txt'))
    expected  = %w( ns2.registry.jobs ns1.registry.jobs )
    assert_equal_and_cached expected, parser, :nameservers

    parser    = @klass.new(load_part('available.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers
  end

  def test_nameservers_with_no_nameserver
    parser    = @klass.new(load_part('property_nameserver_no_nameserver.txt'))
    expected  = %w()
    assert_equal_and_cached expected, parser, :nameservers
  end

end
