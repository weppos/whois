require 'test_helper'
require 'whois/answer/parsers/whois.nic.it.rb'

class WhoisNicItTest < Test::Unit::TestCase

  TESTCASE_PATH = File.expand_path(File.dirname(__FILE__) + '/../testcases/responses/whois.nic.it')

  def setup
    @klass  = Whois::Answer::Parsers::WhoisNicIt
    @server = Whois::Server.factory(:tld, ".it", "whois.nic.it")
    @answer = Whois::Answer
  end


  def test_disclaimer
    assert_equal  "Please note that the following result could be a subgroup of the data contained in the database. Additional information can be visualized at: http://www.nic.it/cgi-bin/Whois/whois.cgi",
                  @klass.new(load_answer('/registered.txt')).disclaimer
  end

  def test_disclaimer_with_available
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).disclaimer
  end


  def test_domain
    assert_equal  "google.it",
                  @klass.new(load_answer('/available.txt')).domain
    assert_equal  "google.it",
                  @klass.new(load_answer('/registered.txt')).domain
  end

  def test_domain_id
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).domain_id
    assert_equal  nil,
                  @klass.new(load_answer('/registered.txt')).domain_id
  end


  def test_status
    assert_equal  :available,
                  @klass.new(load_answer('/status_available.txt')).status
    assert_equal  :active,
                  @klass.new(load_answer('/status_active.txt')).status
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
    assert_equal  Time.parse("1999-12-10 00:00:00"),
                  @klass.new(load_answer('/registered.txt')).created_on
  end

  def test_created_on_with_available
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2008-11-27 16:47:22"),
                  @klass.new(load_answer('/registered.txt')).updated_on
  end

  def test_updated_on_with_available
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).updated_on
  end

  def test_expires_on
    assert_equal  Time.parse("2009-11-27"),
                  @klass.new(load_answer('/registered.txt')).expires_on
  end

  def test_expires_on_with_available
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).expires_on
  end


  def test_registrar
    registrar = @klass.new(load_answer('/registered.txt')).registrar
    assert_instance_of Whois::Answer::Registrar, registrar
    assert_equal "REGISTER-MNT", registrar.id
    assert_equal "REGISTER-MNT", registrar.name
    assert_equal "Register.it s.p.a.", registrar.organization
  end

  def test_registrar_with_available
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).registrar
  end


  def test_registrant
    contact = @klass.new(load_answer('/registered.txt')).registrant
    assert_instance_of Whois::Answer::Contact, contact
    assert_equal "GOOG175-ITNIC", contact.id
    assert_equal "Google Ireland Holdings", contact.name
    assert_equal nil, contact.organization
    assert_equal "30 Herbert Street", contact.address
    assert_equal "Dublin", contact.city
    assert_equal nil, contact.country
    assert_equal "IE", contact.country_code
    assert_equal Time.parse("2008-11-27 16:47:22"), contact.created_on
    assert_equal Time.parse("2008-11-27 16:47:22"), contact.updated_on
  end

  def test_registrant_with_available
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).registrant
  end


  def test_admin
    contact = @klass.new(load_answer('/registered.txt')).admin
    assert_instance_of Whois::Answer::Contact, contact
    assert_equal "TT4277-ITNIC", contact.id
    assert_equal "Tsao Tu", contact.name
    assert_equal "Tu Tsao", contact.organization
    assert_equal "30 Herbert Street", contact.address
    assert_equal "Dublin", contact.city
    assert_equal nil, contact.country
    assert_equal "IE", contact.country_code
    assert_equal Time.parse("2008-11-27 16:47:22"), contact.created_on
    assert_equal Time.parse("2008-11-27 16:47:22"), contact.updated_on
  end

  def test_admin_with_available
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).admin
  end


  def test_technical
    contact = @klass.new(load_answer('/registered.txt')).technical
    assert_instance_of Whois::Answer::Contact, contact
    assert_equal "TS7016-ITNIC", contact.id
    assert_equal "Technical Services", contact.name
    assert_equal nil, contact.organization
    assert_equal nil, contact.address
    assert_equal nil, contact.city
    assert_equal nil, contact.country
    assert_equal nil, contact.country_code
    assert_equal nil, contact.created_on
    assert_equal nil, contact.updated_on
  end

  def test_technical_with_available
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).technical
  end


  def test_nameservers
    assert_equal  %w(ns1.google.com ns4.google.com ns2.google.com ns3.google.com),
                  @klass.new(load_answer('/registered.txt')).nameservers
  end

  def test_nameservers_with_available
    assert_equal  nil,
                  @klass.new(load_answer('/available.txt')).nameservers
  end


  def test_changed_question_check_self
    parser = load_answer('/registered.txt').parser
    assert !parser.changed?(parser)
  end

  def test_changed_question_check_internals
    parser = load_answer('/registered.txt').parser
    assert parser.changed?(load_answer('/available.txt').parser)
  end

  def test_changed_question_check_self_with_available
    parser = new_answer(@server, <<-RESPONSE).parser
Domain:             google.it
Status:             AVAILABLE
    RESPONSE

    assert !parser.changed?(parser)
  end

  def test_changed_question_check_internals_with_available
    parser = new_answer(@server, <<-RESPONSE).parser
Domain:             google.it
Status:             AVAILABLE
    RESPONSE

    assert  parser.changed?(new_answer(@server, <<-RESPONSE).parser)
Domain:             weppos.it
Status:             AVAILABLE
    RESPONSE
    assert !parser.changed?(new_answer(@server, <<-RESPONSE).parser)
Domain:             google.it
Status:             AVAILABLE
    RESPONSE
  end

  def test_unchanged_question_check_self
    parser = load_answer('/registered.txt').parser
    assert parser.unchanged?(parser)
  end

  def test_unchanged_question_check_internals
    parser = load_answer('/registered.txt').parser
    assert parser.unchanged?(load_answer('/registered.txt').parser)
  end

  def test_unchanged_question_check_self_with_available
    parser = new_answer(@server, <<-RESPONSE).parser
Domain:             google.it
Status:             AVAILABLE
    RESPONSE

    assert  parser.unchanged?(parser)
  end

  def test_unchanged_question_check_internals_with_available
    parser = new_answer(@server, <<-RESPONSE).parser
Domain:             google.it
Status:             AVAILABLE
    RESPONSE

    assert  parser.unchanged?(new_answer(@server, <<-RESPONSE).parser)
Domain:             google.it
Status:             AVAILABLE
    RESPONSE
    assert !parser.unchanged?(new_answer(@server, <<-RESPONSE).parser)
Domain:             weppos.it
Status:             AVAILABLE
    RESPONSE
  end


  protected
  
    def load_answer(path)
      new_answer(@server, File.read(TESTCASE_PATH + path))
    end

    def new_answer(server, content)
      @answer.new(server, [Whois::Answer::Part.new(content, server.host)])
    end

end