require 'test_helper'

class SuperStructTest < Test::Unit::TestCase

  SuperEroe = Class.new(SuperStruct.new(:name, :supername))

  def setup
    @klass = SuperEroe
  end

  def test_initialize_with_block
    @klass.new do |instance|
      assert_instance_of  SuperEroe, instance
      assert_kind_of      SuperStruct, instance
    end
  end

  def test_initialize_with_hash
    instance = @klass.new(:name => "Pippo", :supername => "SuperPippo")
    assert_equal "Pippo", instance.name
    assert_equal "SuperPippo", instance.supername
  end

end