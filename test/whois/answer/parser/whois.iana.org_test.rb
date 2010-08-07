require 'test_helper'
require 'whois/answer/parser/whois.iana.org'
require 'whois/answer/nameserver.rb'
require 'whois/answer/contact.rb'

class AnswerParserWhoisIanaOrgTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisIanaOrg

    @host   = "whois.iana.org"

    @nameservers = 
      [Whois::Answer::Nameserver.new(
          :name         => "MAX.NRA.NATO.INT",
          :ipv4         => "192.101.252.69",
          :ipv6         => nil
        ),
        Whois::Answer::Nameserver.new(
          :name         => "MAXIMA.NRA.NATO.INT",
          :ipv4         => "193.110.130.68",
          :ipv6         => nil
        ),
        Whois::Answer::Nameserver.new(
          :name         => "NS.NAMSA.NATO.INT",
          :ipv4         => "208.161.248.15",
          :ipv6         => nil
        ),
        Whois::Answer::Nameserver.new(
          :name         => "NS.NC3A.NATO.INT",
          :ipv4         => "195.169.116.6",
          :ipv6         => nil
        )
      ]
      
      @registrant = Whois::Answer::Contact.new(
        :type         => Whois::Answer::Contact::TYPE_REGISTRANT,
        :name         => nil,
        :organization => "North Atlantic Treaty Organization",
        :address      => "Blvd Leopold III",
        :city         => "1110 Brussels",
        :zip          => "Brussels",
        :country      => "Belgium",
        :phone        => nil,
        :fax          => nil,
        :email        => nil
      )
      
      @admin =      Whois::Answer::Contact.new(
        :type         => Whois::Answer::Contact::TYPE_ADMIN,
        :name         => "Aidan Murdock",
        :organization => nil,
        :address      => "SHAPE",
        :city         => "NCSA/SDD/SAL",
        :zip          => "Casteau Hainaut 7010",
        :country      => "Belgium",
        :phone        => "+32 65 44 7244",
        :fax          => "+32 65 44 7221",
        :email        => "aidan.murdock@ncsa.nato.int"
      )
      
      @technical =  Whois::Answer::Contact.new(
        :type         => Whois::Answer::Contact::TYPE_TECHNICAL,
        :name         => "Jack Smits",
        :organization => nil,
        :address      => "SHAPE",
        :city         => "NCSA/SMD",
        :zip          => "Casteau Hainaut 7010",
        :country      => "Belgium",
        :phone        => "+32 65 44 7534",
        :fax          => "+32 65 44 7556",
        :email        => "jack.smits@ncsa.nato.int"
      )
      
  end


  def test_status
    assert_equal  :registered,
                  @klass.new(load_part('/registered.txt')).status
    assert_equal  :available,
                  @klass.new(load_part('/available.txt')).status
    assert_equal  :available,
                  @klass.new(load_part('/not_assigned.txt')).status
  end

  def test_available?
    assert !@klass.new(load_part('/registered.txt')).available?
    assert  @klass.new(load_part('/available.txt')).available?
    assert  @klass.new(load_part('/not_assigned.txt')).available?
  end

  def test_registered?
    assert  @klass.new(load_part('/registered.txt')).registered?
    assert !@klass.new(load_part('/available.txt')).registered?
    assert !@klass.new(load_part('/not_assigned.txt')).registered?
  end


  def test_created_on
    assert_equal  Time.parse("1997-08-26"),
                  @klass.new(load_part('/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/not_assigned.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-11-10"),
                  @klass.new(load_part('/registered.txt')).updated_on
                  
    assert_equal  Time.parse("1999-09-27"),
                  @klass.new(load_part('/not_assigned.txt')).updated_on
                  
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).updated_on
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/not_assigned.txt')).expires_on }
    
  end

  def test_contacts
    parser    = @klass.new(load_part('/registered.txt'))
    assert_equal @registrant, parser.registrant_contact
    assert_equal @admin, parser.admin_contact
    assert_equal @technical, parser.technical_contact
        
    parser    = @klass.new(load_part('/available.txt'))
    assert_equal nil, parser.registrant_contact
    assert_equal nil, parser.admin_contact
    assert_equal nil, parser.technical_contact
        
    parser    = @klass.new(load_part('/not_assigned.txt'))
    assert_equal nil, parser.registrant_contact
    assert_equal nil, parser.admin_contact
    assert_equal nil, parser.technical_contact
    
  end

  def test_nameservers
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = @nameservers
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
    
    parser    = @klass.new(load_part('/not_assigned.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end