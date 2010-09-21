require 'test_helper'

class Whois::Answer::PartTest < Test::Unit::TestCase

  def setup
    @klass = Whois::Answer::Part
  end

  def test_initialize_with_empty_values
    instance = @klass.new
    assert_instance_of @klass, instance
    assert_equal nil, instance.body

    instance = @klass.new({})
    assert_instance_of @klass, instance
    assert_equal nil, instance.body
  end

  def test_initialize_with_params
    instance = @klass.new("This is a WHOIS record.", "whois.example.test")

    assert_equal "This is a WHOIS record.", instance.body
    assert_equal "whois.example.test",      instance.host
  end

  def test_initialize_with_hash
    instance = @klass.new(:body => "This is a WHOIS record.", :host => "whois.example.test")

    assert_equal "This is a WHOIS record.", instance.body
    assert_equal "whois.example.test",      instance.host
  end

  def test_initialize_with_block
    instance = @klass.new do |c|
      c.body  = "This is a WHOIS record."
      c.host  = "whois.example.test"
    end

    assert_equal "This is a WHOIS record.", instance.body
    assert_equal "whois.example.test",      instance.host
  end


  def test_deprecated_response_setter
    instance = @klass.new(:host => "whois.example.test")
    instance.response = "This is a WHOIS record."

    assert_equal "This is a WHOIS record.", instance.body
    assert_equal "whois.example.test",      instance.host
  end

  def test_deprecated_response_getter
    instance = @klass.new(:body => "This is a WHOIS record.", :host => "whois.example.test")

    assert_equal "This is a WHOIS record.", instance.response
    assert_equal "whois.example.test",      instance.host
  end

end
