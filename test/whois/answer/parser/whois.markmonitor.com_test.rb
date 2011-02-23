require 'test_helper'
require 'whois/answer/parser/whois.markmonitor.com.rb'

class AnswerParserWhoisMarkmonitorComTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisMarkmonitorCom

    @host   = "whois.markmonitor.com"

    @registered = @klass.new(load_part('registered.txt'))

    @registrant = Whois::Answer::Contact.new(
      :type         => Whois::Answer::Contact::TYPE_REGISTRANT,
      :name         => "DNS Admin",
      :organization => "Google Inc.",
      :address      => "1600 Amphitheatre Parkway",
      :city         => "Mountain View",
      :zip          => "94043",
      :state        => "CA",
      :country_code => "US",
      :phone        => "+1.6506234000",
      :fax          => "+1.6506188571",
      :email        => "dns-admin@google.com"
    )

    @admin = Whois::Answer::Contact.new(
      :type         => Whois::Answer::Contact::TYPE_ADMIN,
      :name         => "DNS Admin",
      :organization => "Google Inc.",
      :address      => "1600 Amphitheatre Parkway",
      :city         => "Mountain View",
      :zip          => "94043",
      :state        => "CA",
      :country_code => "US",
      :phone        => "+1.6506234000",
      :fax          => "+1.6506188571",
      :email        => "dns-admin@google.com"
    )

    @technical = Whois::Answer::Contact.new(
      :type         => Whois::Answer::Contact::TYPE_TECHNICAL,
      :name         => "DNS Admin",
      :organization => "Google Inc.",
      :address      => "1600 Amphitheatre Parkway",
      :city         => "Mountain View",
      :zip          => "94043",
      :state        => "CA",
      :country_code => "US",
      :phone        => "+1.6506234000",
      :fax          => "+1.6506188571",
      :email        => "dns-admin@google.com"
    )

  end


  def test_status
    assert_raise(Whois::PropertyNotSupported) { @registered.status }
  end

  def test_available?
    assert_equal_and_cached false, @registered, :available?
  end

  def test_registered?
    assert_equal_and_cached true, @registered, :registered?
  end


  def test_created_on
    expected  = Time.parse("1999-03-15")
    assert_equal_and_cached expected, @registered, :created_on
  end

  def test_expires_on
    expected  = Time.parse("2012-03-14")
    assert_equal_and_cached expected, @registered, :expires_on
  end

  def test_updated_on
    expected  = Time.parse("2011-02-11")
    assert_equal_and_cached expected, @registered, :updated_on
  end


  def test_contacts
    assert_equal @registrant, @registered.registrant_contact
    assert_equal @admin,      @registered.admin_contact
    assert_equal @technical,  @registered.technical_contact
  end


  def test_nameservers
    names     = %w( ns2.google.com ns1.google.com ns4.google.com ns3.google.com )
    expected  = names.map { |name| nameserver(name) }
    assert_equal_and_cached expected, @registered, :nameservers
  end

end
