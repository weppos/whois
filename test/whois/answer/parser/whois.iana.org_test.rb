require 'test_helper'
require 'whois/answer/parser/whois.iana.org'

class AnswerParserWhoisIanaOrgTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisIanaOrg

    @host   = "whois.iana.org"


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
    parser    = @klass.new(load_part('registered.txt'))
    expected  = :registered
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('available.txt'))
    expected  = :available
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('not_assigned.txt'))
    expected  = :available
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    parser    = @klass.new(load_part('registered.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('available.txt'))
    expected  = true
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('not_assigned.txt'))
    expected  = true
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }
  end

  def test_registered?
    parser    = @klass.new(load_part('registered.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('available.txt'))
    expected  = false
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('not_assigned.txt'))
    expected  = false
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }
  end


  def test_created_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("1997-08-26")
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }

    parser    = @klass.new(load_part('not_assigned.txt'))
    expected  = nil
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }
  end

  def test_updated_on
    parser    = @klass.new(load_part('registered.txt'))
    expected  = Time.parse("2009-11-10")
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }

    parser    = @klass.new(load_part('available.txt'))
    expected  = nil
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }

    parser    = @klass.new(load_part('not_assigned.txt'))
    expected  = Time.parse("1999-09-27")
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('available.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('not_assigned.txt')).expires_on }
  end


  def test_contacts
    parser    = @klass.new(load_part('registered.txt'))
    assert_equal @registrant, parser.registrant_contact
    assert_equal @admin, parser.admin_contact
    assert_equal @technical, parser.technical_contact
        
    parser    = @klass.new(load_part('available.txt'))
    assert_equal nil, parser.registrant_contact
    assert_equal nil, parser.admin_contact
    assert_equal nil, parser.technical_contact
        
    parser    = @klass.new(load_part('not_assigned.txt'))
    assert_equal nil, parser.registrant_contact
    assert_equal nil, parser.admin_contact
    assert_equal nil, parser.technical_contact
    
  end


  def test_nameservers
    # parser    = @klass.new(load_part('registered.txt'))
    # expected  = %w( ... )
    # see test_nameservers_with_registered

    parser    = @klass.new(load_part('available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
    
    parser    = @klass.new(load_part('not_assigned.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

  def test_nameservers_with_registered
    nameservers = [
      Whois::Answer::Nameserver.new(
        :name         => "max.nra.nato.int",
        :ipv4         => "192.101.252.69",
        :ipv6         => nil
      ),
      Whois::Answer::Nameserver.new(
        :name         => "maxima.nra.nato.int",
        :ipv4         => "193.110.130.68",
        :ipv6         => nil
      ),
      Whois::Answer::Nameserver.new(
        :name         => "ns.namsa.nato.int",
        :ipv4         => "208.161.248.15",
        :ipv6         => nil
      ),
      Whois::Answer::Nameserver.new(
        :name         => "ns.nc3a.nato.int",
        :ipv4         => "195.169.116.6",
        :ipv6         => nil
      )
    ]

    parser    = @klass.new(load_part('registered.txt'))
    expected  = nameservers
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end