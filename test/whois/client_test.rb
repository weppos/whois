require 'test_helper'

class ClientTest < Test::Unit::TestCase

  def setup
    @client = Whois::Client.new
  end


  def test_initialize
    client = Whois::Client.new
    assert_instance_of Whois::Client, client
  end

  def test_initialize_with_timeout
    client = Whois::Client.new(:timeout => 100)
    assert_equal 100, client.timeout
  end

  def test_initialize_with_block
    Whois::Client.new do |client|
      assert_instance_of Whois::Client, client
    end
  end


  def test_query_should_cast_qstring_to_string
    server = Object.new
    # I can't use the String because Array#to_s behaves differently
    # on Ruby 1.8.7 and Ruby 1.9.1
    # http://redmine.ruby-lang.org/issues/show/2617
    server.expects(:query).with(instance_of(String))
    Whois::Server.expects(:guess).with(instance_of(String)).returns(server)
    @client.query(["google", ".", "com"])
  end

  def test_query_with_email_address_should_raise
    assert_raise(Whois::ServerNotSupported) { @client.query("weppos@weppos.net") }
  end

  def test_query_with_domain_with_no_whois
    Whois::Server.define(:tld, ".nowhois", nil, :adapter => Whois::Server::Adapters::None)

    error = assert_raise(Whois::NoInterfaceError) { @client.query("domain.nowhois") }
    assert_match /no whois server/, error.message
  end

  def test_query_with_domain_with_web_whois
    Whois::Server.define(:tld, ".webwhois", nil, :adapter => Whois::Server::Adapters::Web, :web => "www.nic.test")

    error = assert_raise(Whois::WebInterfaceError) { @client.query("domain.webwhois") }
    assert_match /no whois server/, error.message
    assert_match /www\.nic\.test/,  error.message
  end

  def test_query_with_timeout
    server = Class.new do
      def query(*args)
        sleep(2)
      end
    end
    Whois::Server.expects(:guess).returns(server.new)
    @client.timeout = 1
    assert_raise(Timeout::Error) { @client.query("foo.com") }
  end

  def test_query_with_unlimited_timeout
    server = Class.new do
      def query(*args)
        sleep(1)
      end
    end
    Whois::Server.expects(:guess).returns(server.new)
    @client.timeout = nil
    assert_nothing_raised { @client.query("foo.com") }
  end

  def test_query_within_timeout
    server = Class.new do
      def query(*args)
        sleep(1)
      end
    end
    Whois::Server.expects(:guess).returns(server.new)
    @client.timeout = 5
    assert_nothing_raised { @client.query("foo.com") }
  end


  need_connectivity do

    def test_query_with_domain
      answer = @client.query("weppos.it")
      assert answer.match?(/Domain:\s+weppos\.it/)
      assert answer.match?(/Created:/)
    end

  end

end