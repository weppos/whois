require 'test_helper'
require 'whois/answer/parser/whois.nic.fr'

class AnswerParserWhoisNicFrTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicFr
    @host   = "whois.nic.fr"
  end

end

class AnswerParserWhoisNicFrFrTest < AnswerParserWhoisNicFrTest

  def test_status
    parser    = @klass.new(load_part('/fr/registered.txt'))
    expected  = :registered
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/fr/available.txt'))
    expected  = :available
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    parser    = @klass.new(load_part('/fr/registered.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('/fr/available.txt'))
    expected  = true
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }
  end

  def test_registered?
    parser    = @klass.new(load_part('/fr/registered.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('/fr/available.txt'))
    expected  = false
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }
  end


  def test_created_on
    assert_equal  Time.parse("2000-07-27"),
                  @klass.new(load_part('/fr/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/fr/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-06-03"),
                  @klass.new(load_part('/fr/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/fr/available.txt')).updated_on
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/fr/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/fr/available.txt')).expires_on }
  end


  def test_nameservers
    parser    = @klass.new(load_part('/fr/registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/fr/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end

class AnswerParserWhoisNicFrPmTest < AnswerParserWhoisNicFrTest

  def test_status
    parser    = @klass.new(load_part('/pm/registered.txt'))
    expected  = :registered
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/pm/available.txt'))
    expected  = :available
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    parser    = @klass.new(load_part('/pm/registered.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('/pm/available.txt'))
    expected  = true
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }
  end

  def test_registered?
    parser    = @klass.new(load_part('/pm/registered.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('/pm/available.txt'))
    expected  = false
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }
  end


  def test_created_on
    assert_equal  Time.parse("1995-01-01"),
                  @klass.new(load_part('/pm/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/pm/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2004-09-17"),
                  @klass.new(load_part('/pm/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/pm/available.txt')).updated_on
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/pm/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/pm/available.txt')).expires_on }
  end


  def test_nameservers
    parser    = @klass.new(load_part('/pm/registered.txt'))
    expected  = %w( ns1.nic.fr ns2.nic.fr ns3.nic.fr )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/pm/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end

class AnswerParserWhoisNicFrReTest < AnswerParserWhoisNicFrTest

  def test_status
    parser    = @klass.new(load_part('/re/registered.txt'))
    expected  = :registered
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/re/available.txt'))
    expected  = :available
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    parser    = @klass.new(load_part('/re/registered.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('/re/available.txt'))
    expected  = true
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }
  end

  def test_registered?
    parser    = @klass.new(load_part('/re/registered.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('/re/available.txt'))
    expected  = false
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }
  end


  def test_created_on
    assert_equal  Time.parse("1995-01-01"),
                  @klass.new(load_part('/re/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/re/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-03-12"),
                  @klass.new(load_part('/re/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/re/available.txt')).updated_on
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/re/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/re/available.txt')).expires_on }
  end


  def test_nameservers
    parser    = @klass.new(load_part('/pm/registered.txt'))
    expected  = %w( ns1.nic.fr ns2.nic.fr ns3.nic.fr )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/pm/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end

class AnswerParserWhoisNicFrWfTest < AnswerParserWhoisNicFrTest

  def test_status
    parser    = @klass.new(load_part('/wf/registered.txt'))
    expected  = :registered
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/wf/available.txt'))
    expected  = :available
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    parser    = @klass.new(load_part('/wf/registered.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('/wf/available.txt'))
    expected  = true
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }
  end

  def test_registered?
    parser    = @klass.new(load_part('/wf/registered.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('/wf/available.txt'))
    expected  = false
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }
  end


  def test_created_on
    assert_equal  Time.parse("1995-01-01"),
                  @klass.new(load_part('/wf/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/wf/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2004-09-17"),
                  @klass.new(load_part('/wf/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/wf/available.txt')).updated_on
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/wf/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/wf/available.txt')).expires_on }
  end


  def test_nameservers
    parser    = @klass.new(load_part('/wf/registered.txt'))
    expected  = %w( ns1.nic.fr ns2.nic.fr ns3.nic.fr )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/wf/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end

class AnswerParserWhoisNicFrYtTest < AnswerParserWhoisNicFrTest

  def test_status
    parser    = @klass.new(load_part('/yt/registered.txt'))
    expected  = :registered
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/yt/available.txt'))
    expected  = :available
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    parser    = @klass.new(load_part('/yt/registered.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('/yt/available.txt'))
    expected  = true
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }
  end

  def test_registered?
    parser    = @klass.new(load_part('/yt/registered.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('/yt/available.txt'))
    expected  = false
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }
  end


  def test_created_on
    assert_equal  Time.parse("1995-01-01"),
                  @klass.new(load_part('/yt/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/yt/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2004-09-17"),
                  @klass.new(load_part('/yt/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/yt/available.txt')).updated_on
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/yt/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/yt/available.txt')).expires_on }
  end


  def test_nameservers
    parser    = @klass.new(load_part('/yt/registered.txt'))
    expected  = %w( ns1.nic.fr ns2.nic.fr ns3.nic.fr )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/yt/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end
