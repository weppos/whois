require "spec_helper"

describe Whois::Answer::Parser do

  before(:each) do
    @answer = Whois::Answer.new(nil, [])
  end


  describe "#changed?" do
    it "raises if the argument is not an instance of the same class" do
      lambda do
        klass.new(@answer).changed?(Object.new)
      end.should raise_error

      lambda do
        klass.new(@answer).changed?(klass.new(@answer))
      end.should_not raise_error
    end
  end

  describe "#unchanged?" do
    it "raises if the argument is not an instance of the same class" do
      lambda do
        klass.new(@answer).unchanged?(Object.new)
      end.should raise_error

      lambda do
        klass.new(@answer).unchanged?(klass.new(@answer))
      end.should_not raise_error
    end

    it "returns true if self and other references the same object" do
      instance = klass.new(@answer)
      instance.unchanged?(instance).should be_true
    end

    it "returns false if parser and other.parser have different number of elements" do
      instance = klass.new(Whois::Answer.new(nil, []))
      other    = klass.new(Whois::Answer.new(nil, [Whois::Answer::Part.new("", "foo.example.test")]))
      instance.unchanged?(other).should be_false
    end

    it "returns true if parsers and other.parsers have 0 elements" do
      instance = klass.new(Whois::Answer.new(nil, []))
      other    = klass.new(Whois::Answer.new(nil, []))
      instance.unchanged?(other).should be_true
    end
  end

  it "returns true if every parser in self marches the corresponding parser in other" do
    instance = klass.new(Whois::Answer.new(nil, [Whois::Answer::Part.new("hello", "foo.example.test"), Whois::Answer::Part.new("world", "bar.example.test")]))
    other    = klass.new(Whois::Answer.new(nil, [Whois::Answer::Part.new("hello", "foo.example.test"), Whois::Answer::Part.new("world", "bar.example.test")]))

    instance.unchanged?(other).should be_true
  end

  it "returns false unless every parser in self marches the corresponding parser in other" do
    instance = klass.new(Whois::Answer.new(nil, [Whois::Answer::Part.new("hello", "foo.example.test"), Whois::Answer::Part.new("world", "bar.example.test")]))
    other    = klass.new(Whois::Answer.new(nil, [Whois::Answer::Part.new("hello", "foo.example.test"), Whois::Answer::Part.new("baby!", "bar.example.test")]))

    instance.unchanged?(other).should be_false
  end

end
