require 'test_helper'

class AnswerContactTest < Test::Unit::TestCase

  def setup
    @klass = Whois::Answer::Contact
  end

  def test_initialize
    contact = @klass.new({})
    assert_equal nil, contact.id
  end

end