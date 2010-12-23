require "spec_helper"

describe Whois::Answer do

  before(:each) do
    @server   = Whois::Server.factory(:tld, ".foo", "whois.example.test")
    @parts    = [
        Whois::Answer::Part.new("This is a answer from foo.", "foo.example.test"),
        Whois::Answer::Part.new("This is a answer from bar.", "bar.example.test")
    ]
    @content  = "This is a answer from foo.\nThis is a answer from bar."
    @answer   = klass.new(@server, @parts)
  end


  describe "#==" do
    it "returns true when other is the same instance" do
      one = two = klass.new(@server, @parts)

      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns true when other has same class and has the same parts" do
      one, two = klass.new(@server, @parts), klass.new(@server, @parts)

      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns true when other has descendant class and has the same parts" do
      subklass = Class.new(klass)
      one, two = klass.new(@server, @parts), subklass.new(@server, @parts)

      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns true when other has same class and has equal parts" do
      one, two = klass.new(@server, @parts), klass.new(@server, @parts.dup)
      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns true when other has same class, different server and the same parts" do
      one, two = klass.new(@server, @parts), klass.new(nil, @parts)
      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns false when other has different class and has the same parts" do
      one, two = klass.new(@server, @parts), Struct.new(:server, :parts).new(@server, @parts)

      (one == two).should be_false
      (one.eql? two).should be_false
    end

    it "returns false when other has different parts" do
      one, two = klass.new(@server, @parts), klass.new(@server, [])

      (one == two).should be_false
      (one.eql? two).should be_false
    end

    it "returns true when other is string and has the same content", :deprecated => true do
      one, two = klass.new(@server, @parts), klass.new(@server, @parts).to_s

      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns false when other is string and has different content", :deprecated => true do
      one, two = klass.new(@server, @parts), "different"

      (one == two).should be_false
      (one.eql? two).should be_false
    end
  end


  describe "#changed?" do
    it "raises if the argument is not an instance of the same class" do
      lambda do
        klass.new(nil, []).changed?(Object.new)
      end.should raise_error

      lambda do
        klass.new(nil, []).changed?(klass.new(nil, []))
      end.should_not raise_error
    end
  end

  describe "#unchanged?" do
    it "raises if the argument is not an instance of the same class" do
      lambda do
        klass.new(nil, []).unchanged?(Object.new)
      end.should raise_error

      lambda do
        klass.new(nil, []).unchanged?(klass.new(nil, []))
      end.should_not raise_error
    end

    it "returns true if self and other references the same object" do
      instance = klass.new(nil, [])
      instance.unchanged?(instance).should be_true
    end

    it "delegates to #parser if self and other references different objects" do
      other = klass.new(nil, @parts)
      instance = klass.new(nil, @parts)
      instance.parser.expects(:unchanged?).with(other.parser)

      instance.unchanged?(other)
    end
  end

  describe "#throttle?" do
    it "delegates to #parser" do
      instance = klass.new(nil, @parts)
      instance.parser.expects(:throttle?)

      instance.throttle?
    end
  end

end
