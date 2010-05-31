require 'test_helper'

class WebInterfaceErrorTest < Test::Unit::TestCase

  def setup
    @klass = Whois::WebInterfaceError
  end

  def test_url
    assert_raise(ArgumentError) { @klass.new }
  end

  def test_url
    error = @klass.new("http://example.com")
    assert_equal "http://example.com", error.url
  end

  def test_message
    error = @klass.new("http://example.com")
    assert_match %r{http://example.com}, error.message
  end

end