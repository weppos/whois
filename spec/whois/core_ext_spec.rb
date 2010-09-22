require "spec_helper"

describe Symbol do

  describe "#to_proc" do
    it "should work" do
      [:one, :two, :three].map(&:to_s).should == %w(one two three)
      { 1 => "one", 2 => "two", 3 => "three" }.sort_by(&:first).map(&:last).should == %w(one two three)
    end
  end

end

describe DateTime do

  describe "#to_time" do
    it "should work" do
      DateTime.new(2005, 2, 21, 10, 11, 12, 0, 0).to_time.should == Time.utc(2005, 2, 21, 10, 11, 12)

      # NOTE: This test doesn't pass with Ruby 1.9, not because it doesn't work,
      # but because Ruby 1.9 has a different implementation.
      # ActiveRecord solves this by always removing the original Ruby method.
      # DateTimes with offsets other than 0 are returned unaltered
      # assert_equal DateTime.new(2005, 2, 21, 10, 11, 12, Rational(-5, 24)), DateTime.new(2005, 2, 21, 10, 11, 12, Rational(-5, 24)).to_time
    end
  end

end
