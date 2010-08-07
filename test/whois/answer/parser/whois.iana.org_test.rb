require 'test_helper'
require 'whois/answer/parser/whois.iana.org'
require 'whois/answer/nameserver.rb'

class AnswerParserWhoisIanaOrgTest < Whois::Answer::Parser::TestCase

  def setup
    @klass  = Whois::Answer::Parser::WhoisIanaOrg
    @nsklass  = Whois::Answer::Nameserver
    @host   = "whois.iana.org"
    @nameservers = [
        @nsklass.new(
          :name         => "MAX.NRA.NATO.INT",
          :ipv4         => "192.101.252.69",
          :ipv6         => nil
        ),
        @nsklass.new(
          :name         => "MAXIMA.NRA.NATO.INT",
          :ipv4         => "193.110.130.68",
          :ipv6         => nil
        ),
       @nsklass.new(
          :name         => "NS.NAMSA.NATO.INT",
          :ipv4         => "208.161.248.15",
          :ipv6         => nil
        ),
        @nsklass.new(
          :name         => "NS.NC3A.NATO.INT",
          :ipv4         => "195.169.116.6",
          :ipv6         => nil
        )
      ]
  end


  def test_status
    assert_equal  :registered,
                  @klass.new(load_part('/registered.txt')).status
    assert_equal  :available,
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
    assert_equal  Time.parse("1997-08-26"),
                  @klass.new(load_part('/registered.txt')).created_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).created_on
  end

  def test_updated_on
    assert_equal  Time.parse("2009-11-10"),
                  @klass.new(load_part('/registered.txt')).updated_on
    assert_equal  nil,
                  @klass.new(load_part('/available.txt')).updated_on
  end

  def test_expires_on
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/registered.txt')).expires_on }
    assert_raise(Whois::PropertyNotSupported) { @klass.new(load_part('/available.txt')).expires_on }
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
  end

end