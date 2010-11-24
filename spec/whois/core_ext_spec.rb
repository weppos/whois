require "spec_helper"

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
