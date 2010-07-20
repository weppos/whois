require 'test_helper'
require 'whois/answer/parser/whois.centralnic.net'

class AnswerParserWhoisCentralnicNetTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisCentralnicNet
    @host   = "whois.centralnic.net"
  end

end
class AnswerParserWhoisCentralnicNetBrComTest < AnswerParserWhoisCentralnicNetTest

  def test_disclaimer
    parser    = @klass.new(load_part('/br.com/registered.txt'))
    expected  = "This whois service is provided by CentralNic Ltd and only contains information pertaining to Internet domain names we have registered for our customers. By using this service you are agreeing (1) not to use any information presented here for any purpose other than determining ownership of domain names (2) not to store or reproduce this data in any way. CentralNic Ltd - www.centralnic.com"
    assert_equal  expected, parser.disclaimer
    assert_equal  expected, parser.instance_eval { @disclaimer }

    parser    = @klass.new(load_part('/br.com/available.txt'))
    expected  = "This whois service is provided by CentralNic Ltd and only contains information pertaining to Internet domain names we have registered for our customers. By using this service you are agreeing (1) not to use any information presented here for any purpose other than determining ownership of domain names (2) not to store or reproduce this data in any way. CentralNic Ltd - www.centralnic.com"
    assert_equal  expected, parser.disclaimer
    assert_equal  expected, parser.instance_eval { @disclaimer }
  end


  def test_domain
    parser    = @klass.new(load_part('/br.com/registered.txt'))
    expected  = "billboard.br.com"
    assert_equal  expected, parser.domain
    assert_equal  expected, parser.instance_eval { @domain }

    parser    = @klass.new(load_part('/br.com/available.txt'))
    expected  = "u34jedzcq.br.com"
    assert_equal  expected, parser.domain
    assert_equal  expected, parser.instance_eval { @domain }
  end

  def test_domain_id
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/br.com/registered.txt')).domain_id }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/br.com/available.txt')).domain_id }
  end


  def test_referral_whois
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/br.com/registered.txt')).referral_whois }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/br.com/available.txt')).referral_whois }
  end

  def test_referral_url
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/br.com/registered.txt')).referral_url }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/br.com/available.txt')).referral_url }
  end


  def test_status
    parser    = @klass.new(load_part('/br.com/registered.txt'))
    expected  = "Live"
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/br.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    parser    = @klass.new(load_part('/br.com/registered.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('/br.com/available.txt'))
    expected  = true
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }
  end

  def test_registered?
    parser    = @klass.new(load_part('/br.com/registered.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('/br.com/available.txt'))
    expected  = false
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }
  end


  def test_created_on
    parser    = @klass.new(load_part('/br.com/registered.txt'))
    expected  = Time.parse("2009-04-17")
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }

    parser    = @klass.new(load_part('/br.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/br.com/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/br.com/available.txt')).updated_on }
  end

  def test_expires_on
    parser    = @klass.new(load_part('/br.com/registered.txt'))
    expected  = Time.parse("2011-04-17")
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }

    parser    = @klass.new(load_part('/br.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }
  end


  def test_registrar_with_registered
    parser    = @klass.new(load_part('/br.com/registered.txt'))
    expected  = parser.registrar
    assert_equal  expected, parser.registrar
    assert_equal  expected, parser.instance_eval { @registrar }

    assert_instance_of Whois::Answer::Registrar, expected
    assert_equal "H292913", expected.id
  end

  def test_registrar_with_available
    parser    = @klass.new(load_part('/br.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.registrar
    assert_equal  expected, parser.instance_eval { @registrar }
  end

  def test_registrar
    parser    = @klass.new(load_part('/br.com/registered.txt'))
    result    = parser.registrar

    assert_instance_of Whois::Answer::Registrar,  result
    assert_equal "H292913", result.id
    assert_equal "Domain Administrator, Network Solutions LLC", result.name
    assert_equal "Domain Administrator, Network Solutions LLC", result.organization
  end


  def test_registrant_contact_with_registered
    parser    = @klass.new(load_part('/br.com/registered.txt'))
    expected  = nil
    assert_equal  expected, parser.registrant_contact
    assert_equal  expected, parser.instance_eval { @registrant_contact }
  end

  def test_registrant_contact_with_available
    parser    = @klass.new(load_part('/br.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.registrant_contact
    assert_equal  expected, parser.instance_eval { @registrant_contact }
  end

  def test_admin_contact_with_registered
    parser    = @klass.new(load_part('/br.com/registered.txt'))
    expected  = nil
    assert_equal  expected, parser.admin_contact
    assert_equal  expected, parser.instance_eval { @admin_contact }
  end

  def test_admin_contact_with_available
    parser    = @klass.new(load_part('/br.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.admin_contact
    assert_equal  expected, parser.instance_eval { @admin_contact }
  end

  def test_technical_contact_with_registered
    parser    = @klass.new(load_part('/br.com/registered.txt'))
    expected  = nil
    assert_equal  expected, parser.technical_contact
    assert_equal  expected, parser.instance_eval { @technical_contact }
  end

  def test_technical_contact_with_available
    parser    = @klass.new(load_part('/br.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.technical_contact
    assert_equal  expected, parser.instance_eval { @technical_contact }
  end


  def test_nameservers
    parser    = @klass.new(load_part('/br.com/registered.txt'))
    expected  = %w( ns1.uolhostidc.com.br ns2.uolhostidc.com.br )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/br.com/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end


  def test_changed_with_self
    parser1  = @klass.new(load_part('/br.com/registered.txt'))
    assert !parser1.changed?(parser1)
    assert  parser1.unchanged?(parser1)
  end

  def test_changed_with_equal_content
    parser1  = @klass.new(load_part('/br.com/registered.txt'))
    parser2  = @klass.new(load_part('/br.com/registered.txt'))
    assert !parser1.changed?(parser2)
    assert  parser1.unchanged?(parser2)
  end

  def test_changed_with_different_content
    parser1  = @klass.new(load_part('/br.com/registered.txt'))
    parser2  = @klass.new(load_part('/br.com/available.txt'))
    assert  parser1.changed?(parser2)
    assert !parser1.unchanged?(parser2)
  end

end

class AnswerParserWhoisCentralnicNetCnComTest < AnswerParserWhoisCentralnicNetTest

  def test_disclaimer
    parser    = @klass.new(load_part('/cn.com/registered.txt'))
    expected  = "This whois service is provided by CentralNic Ltd and only contains information pertaining to Internet domain names we have registered for our customers. By using this service you are agreeing (1) not to use any information presented here for any purpose other than determining ownership of domain names (2) not to store or reproduce this data in any way. CentralNic Ltd - www.centralnic.com"
    assert_equal  expected, parser.disclaimer
    assert_equal  expected, parser.instance_eval { @disclaimer }

    parser    = @klass.new(load_part('/cn.com/available.txt'))
    expected  = "This whois service is provided by CentralNic Ltd and only contains information pertaining to Internet domain names we have registered for our customers. By using this service you are agreeing (1) not to use any information presented here for any purpose other than determining ownership of domain names (2) not to store or reproduce this data in any way. CentralNic Ltd - www.centralnic.com"
    assert_equal  expected, parser.disclaimer
    assert_equal  expected, parser.instance_eval { @disclaimer }
  end


  def test_domain
    parser    = @klass.new(load_part('/cn.com/registered.txt'))
    expected  = "gsn.cn.com"
    assert_equal  expected, parser.domain
    assert_equal  expected, parser.instance_eval { @domain }

    parser    = @klass.new(load_part('/cn.com/available.txt'))
    expected  = "u34jedzcq.cn.com"
    assert_equal  expected, parser.domain
    assert_equal  expected, parser.instance_eval { @domain }
  end

  def test_domain_id
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/cn.com/registered.txt')).domain_id }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/cn.com/available.txt')).domain_id }
  end


  def test_referral_whois
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/cn.com/registered.txt')).referral_whois }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/cn.com/available.txt')).referral_whois }
  end

  def test_referral_url
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/cn.com/registered.txt')).referral_url }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/cn.com/available.txt')).referral_url }
  end


  def test_status
    parser    = @klass.new(load_part('/cn.com/registered.txt'))
    expected  = "Live"
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/cn.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    parser    = @klass.new(load_part('/cn.com/registered.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('/cn.com/available.txt'))
    expected  = true
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }
  end

  def test_registered?
    parser    = @klass.new(load_part('/cn.com/registered.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('/cn.com/available.txt'))
    expected  = false
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }
  end


  def test_created_on
    parser    = @klass.new(load_part('/cn.com/registered.txt'))
    expected  = Time.parse("2005-11-23")
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }

    parser    = @klass.new(load_part('/cn.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }
  end

  def test_updated_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/cn.com/registered.txt')).updated_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/cn.com/available.txt')).updated_on }
  end

  def test_expires_on
    parser    = @klass.new(load_part('/cn.com/registered.txt'))
    expected  = Time.parse("2010-11-23")
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }

    parser    = @klass.new(load_part('/cn.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }
  end


  def test_registrar_with_registered
    parser    = @klass.new(load_part('/cn.com/registered.txt'))
    expected  = parser.registrar
    assert_equal  expected, parser.registrar
    assert_equal  expected, parser.instance_eval { @registrar }

    assert_instance_of Whois::Answer::Registrar, expected
    assert_equal "H292913", expected.id
  end

  def test_registrar_with_available
    parser    = @klass.new(load_part('/cn.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.registrar
    assert_equal  expected, parser.instance_eval { @registrar }
  end

  def test_registrar
    parser    = @klass.new(load_part('/cn.com/registered.txt'))
    result    = parser.registrar

    assert_instance_of Whois::Answer::Registrar,  result
    assert_equal "H292913", result.id
    assert_equal "Domain Administrator, Network Solutions LLC", result.name
    assert_equal "Domain Administrator, Network Solutions LLC", result.organization
  end


  def test_registrant_contact_with_registered
    parser    = @klass.new(load_part('/cn.com/registered.txt'))
    expected  = nil
    assert_equal  expected, parser.registrant_contact
    assert_equal  expected, parser.instance_eval { @registrant_contact }
  end

  def test_registrant_contact_with_available
    parser    = @klass.new(load_part('/cn.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.registrant_contact
    assert_equal  expected, parser.instance_eval { @registrant_contact }
  end

  def test_admin_contact_with_registered
    parser    = @klass.new(load_part('/cn.com/registered.txt'))
    expected  = nil
    assert_equal  expected, parser.admin_contact
    assert_equal  expected, parser.instance_eval { @admin_contact }
  end

  def test_admin_contact_with_available
    parser    = @klass.new(load_part('/cn.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.admin_contact
    assert_equal  expected, parser.instance_eval { @admin_contact }
  end

  def test_technical_contact_with_registered
    parser    = @klass.new(load_part('/cn.com/registered.txt'))
    expected  = nil
    assert_equal  expected, parser.technical_contact
    assert_equal  expected, parser.instance_eval { @technical_contact }
  end

  def test_technical_contact_with_available
    parser    = @klass.new(load_part('/cn.com/available.txt'))
    expected  = nil
    assert_equal  expected, parser.technical_contact
    assert_equal  expected, parser.instance_eval { @technical_contact }
  end


  def test_nameservers
    parser    = @klass.new(load_part('/cn.com/registered.txt'))
    expected  = %w( ns1.meteos.it ns2.meteos.it )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/cn.com/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end


  def test_changed_with_self
    parser1  = @klass.new(load_part('/cn.com/registered.txt'))
    assert !parser1.changed?(parser1)
    assert  parser1.unchanged?(parser1)
  end

  def test_changed_with_equal_content
    parser1  = @klass.new(load_part('/cn.com/registered.txt'))
    parser2  = @klass.new(load_part('/cn.com/registered.txt'))
    assert !parser1.changed?(parser2)
    assert  parser1.unchanged?(parser2)
  end

  def test_changed_with_different_content
    parser1  = @klass.new(load_part('/cn.com/registered.txt'))
    parser2  = @klass.new(load_part('/cn.com/available.txt'))
    assert  parser1.changed?(parser2)
    assert !parser1.unchanged?(parser2)
  end

end
