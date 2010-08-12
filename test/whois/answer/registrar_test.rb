require 'test_helper'

class Whois::Answer::RegistrarTest < Test::Unit::TestCase

  def setup
    @klass = Whois::Answer::Registrar
  end

  def test_initialize_with_empty_values
    instance = @klass.new
    assert_instance_of @klass, instance
    assert_equal nil, instance.id

    instance = @klass.new({})
    assert_instance_of @klass, instance
    assert_equal nil, instance.id
  end

  def test_initialize_with_params
    instance = @klass.new(10, "John Doe", nil, "http://example.com")

    assert_equal 10,                    instance.id
    assert_equal "John Doe",            instance.name
    assert_equal nil,                   instance.organization
    assert_equal "http://example.com",  instance.url
  end

  def test_initialize_with_hash
    instance = @klass.new(:id => 10, :name => "John Doe", :url => "http://example.com")

    assert_equal 10,                    instance.id
    assert_equal "John Doe",            instance.name
    assert_equal nil,                   instance.organization
    assert_equal "http://example.com",  instance.url
  end

  def test_initialize_with_block
    instance = @klass.new do |c|
      c.id    = 10
      c.name  = "John Doe"
      c.url   = "http://example.com"
    end

    assert_equal 10,                    instance.id
    assert_equal "John Doe",            instance.name
    assert_equal nil,                   instance.organization
    assert_equal "http://example.com",  instance.url
  end

end
