require 'test_helper'
require 'whois/answer/parser/whois.nic.uk'

class AnswerParserWhoisNicUkTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicUk
    @host   = "whois.nic.uk"
  end


  def test_status
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = :registered
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = :available
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/property_status_suspended.txt'))
    expected  = :registered
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }

    parser    = @klass.new(load_part('/property_status_processing_renewal.txt'))
    expected  = :registered
    assert_equal  expected, parser.status
    assert_equal  expected, parser.instance_eval { @status }
  end

  def test_available?
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = true
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('/property_status_suspended.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }

    parser    = @klass.new(load_part('/property_status_processing_renewal.txt'))
    expected  = false
    assert_equal  expected, parser.available?
    assert_equal  expected, parser.instance_eval { @available }
  end

  def test_registered?
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = false
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('/property_status_suspended.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }

    parser    = @klass.new(load_part('/property_status_processing_renewal.txt'))
    expected  = true
    assert_equal  expected, parser.registered?
    assert_equal  expected, parser.instance_eval { @registered }
  end

  def test_valid?
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = true
    assert_equal  expected, parser.valid?
    assert_equal  expected, parser.instance_eval { @valid }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = true
    assert_equal  expected, parser.valid?
    assert_equal  expected, parser.instance_eval { @valid }

    parser    = @klass.new(load_part('/invalid.txt'))
    expected  = false
    assert_equal  expected, parser.valid?
    assert_equal  expected, parser.instance_eval { @valid }
  end

  def test_invalid?
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = false
    assert_equal  expected, parser.invalid?
    assert_equal  expected, parser.instance_eval { @invalid }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = false
    assert_equal  expected, parser.invalid?
    assert_equal  expected, parser.instance_eval { @invalid }

    parser    = @klass.new(load_part('/invalid.txt'))
    expected  = true
    assert_equal  expected, parser.invalid?
    assert_equal  expected, parser.instance_eval { @invalid }
  end


  def test_created_on
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = Time.parse("1999-02-14")
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.created_on
    assert_equal  expected, parser.instance_eval { @created_on }
  end

  def test_updated_on
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = Time.parse("2009-08-13")
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.updated_on
    assert_equal  expected, parser.instance_eval { @updated_on }
  end

  def test_expires_on
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = Time.parse("2011-02-14")
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = nil
    assert_equal  expected, parser.expires_on
    assert_equal  expected, parser.instance_eval { @expires_on }
  end


  def test_nameservers
    parser    = @klass.new(load_part('/registered.txt'))
    expected  = %w( ns1.google.com ns2.google.com ns3.google.com ns4.google.com )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }

    parser    = @klass.new(load_part('/available.txt'))
    expected  = %w()
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

  # TEST:REGRESSION
  def test_nameservers_with_suspended
    parser    = @klass.new(load_part('/property_status_suspended.txt'))
    expected  = %w( )
    assert_equal  expected, parser.nameservers
    assert_equal  expected, parser.instance_eval { @nameservers }
  end

end
