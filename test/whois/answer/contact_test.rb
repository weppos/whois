require 'test_helper'

class Whois::Answer::ContactTest < Test::Unit::TestCase

  def setup
    @klass = Whois::Answer::Contact
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
    instance = @klass.new(10, @klass::TYPE_REGISTRANT, "John Doe", nil)

    assert_equal 10,                      instance.id
    assert_equal @klass::TYPE_REGISTRANT, instance.type
    assert_equal "John Doe",              instance.name
    assert_equal nil,                     instance.organization
  end

  def test_initialize_with_hash
    instance = @klass.new(:id => 10, :name => "John Doe", :type => @klass::TYPE_REGISTRANT)

    assert_equal 10,                      instance.id
    assert_equal @klass::TYPE_REGISTRANT, instance.type
    assert_equal "John Doe",              instance.name
    assert_equal nil,                     instance.organization
  end

  def test_initialize_with_block
    instance = @klass.new do |c|
      c.id    = 10
      c.type  = @klass::TYPE_REGISTRANT
      c.name  = "John Doe"
    end

    assert_equal 10,                      instance.id
    assert_equal @klass::TYPE_REGISTRANT, instance.type
    assert_equal "John Doe",              instance.name
    assert_equal nil,                     instance.organization
  end

end
