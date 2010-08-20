require 'test_helper'

class SymbolTests < Test::Unit::TestCase

  def test_to_proc
    assert_equal %w(one two three), [:one, :two, :three].map(&:to_s)
    assert_equal(%w(one two three), { 1 => "one", 2 => "two", 3 => "three" }.sort_by(&:first).map(&:last))
  end

end


class DateTimeExtCalculationsTest < Test::Unit::TestCase

  def test_to_time
    assert_equal Time.utc(2005, 2, 21, 10, 11, 12), DateTime.new(2005, 2, 21, 10, 11, 12, 0, 0).to_time
    # DateTimes with offsets other than 0 are returned unaltered
    assert_equal DateTime.new(2005, 2, 21, 10, 11, 12, Rational(-5, 24)), DateTime.new(2005, 2, 21, 10, 11, 12, Rational(-5, 24)).to_time
  end

end
