require 'test_helper'

class SuperStructTest < Test::Unit::TestCase

  Supereroe = Class.new(SuperStruct.new(:name, :supername))

  
  def setup
    @klass = Supereroe
  end

  def test_initialize_with_block
    @klass.new do |instance|
      assert_instance_of  Supereroe, instance
      assert_kind_of      SuperStruct, instance
    end
  end

  def test_initialize_with_hash
    instance = @klass.new(:name => "Pippo", :supername => "SuperPippo")
    assert_equal "Pippo", instance.name
    assert_equal "SuperPippo", instance.supername
  end

end