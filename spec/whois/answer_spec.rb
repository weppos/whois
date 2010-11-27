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
