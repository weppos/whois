require "spec_helper"

describe Whois::Server::Adapters::Base do

  before(:each) do
    @definition = [:tld, ".test", "whois.test", { :foo => "bar" }]
    @allow_incomplete_responses_definition = [:tld, ".test", "whois.test", { :foo => "bar", :allow_incomplete_responses => true} ]
  end


  describe "#initialize" do
    it "requires type, allocation, and host parameters" do
      lambda { klass.new(:tld) }.should raise_error(ArgumentError)
      lambda { klass.new(:tld, ".test") }.should raise_error(ArgumentError)
      lambda { klass.new(:tld, ".test", "whois.test") }.should_not raise_error
    end

    it "accepts an options parameter" do
      lambda { klass.new(:tld, ".test", "whois.test", { :foo => "bar" }) }.should_not raise_error
    end

    it "sets instance variables from arguments" do
      a = klass.new(:tld, ".test", "whois.test", { :foo => "bar" })
      a.type.should == :tld
      a.allocation.should == ".test"
      a.host.should == "whois.test"
      a.options.should == { :foo => "bar" }
    end

    it "defaults options to an empty hash" do
      a = klass.new(:tld, ".test", "whois.test")
      a.options.should == Hash.new
    end
  end

  describe "#==" do
    it "returns true when other is the same instance" do
      one = two = klass.new(*@definition)

      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns true when other has same class and has the same attributes" do
      one, two = klass.new(*@definition), klass.new(*@definition)

      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns true when other has descendant class and has the same attributes" do
      subklass = Class.new(klass)
      one, two = klass.new(*@definition), subklass.new(*@definition)

      (one == two).should be_true
      (one.eql? two).should be_true
    end

    it "returns false when other has different class and has the same attributes" do
      one, two = klass.new(*@definition), Struct.new(:type, :allocation, :host, :options).new(*@definition)

      (one == two).should be_false
      (one.eql? two).should be_false
    end

    it "returns false when other has different attributes" do
      one, two = klass.new(:tld, ".test", "whois.test"), klass.new(:tld, ".cool", "whois.test")

      (one == two).should be_false
      (one.eql? two).should be_false
    end

    it "returns false when other has different options" do
      one, two = klass.new(:tld, ".test", "whois.test"), klass.new(:tld, ".test", "whois.test", { :foo => "bar" })

      (one == two).should be_false
      (one.eql? two).should be_false
    end
  end


  describe "#configure" do
    it "merges settings with current options" do
      a = klass.new(:tld, ".test", "whois.test", { :hello => "world" })
      a.configure(:foo => "bar")
      a.options.should == { :hello => "world", :foo => "bar" }
    end

    it "gives higher priority to settings argument" do
      a = klass.new(:tld, ".test", "whois.test", { :foo => "bar" })
      a.options.should == { :foo => "bar" }
      a.configure(:foo => "baz")
      a.options.should == { :foo => "baz" }
    end
  end


  describe "#query" do
    it "raises NotImplementedError" do
      lambda { klass.new(*@definition).query("example.test") }.should raise_error(NotImplementedError)
    end
  end

  describe "#request" do
    it "is an abstract method" do
      lambda { klass.new(*@definition).request("example.test") }.should raise_error(NotImplementedError)
    end
  end

  describe "#query_the_socket" do
    [ Errno::EHOSTUNREACH, Errno::ECONNREFUSED, SocketError ].each do |error|
      it "re-raises #{error} as Whois::ConnectionError" do
        klass.any_instance.expects(:ask_the_socket).raises(error)
        expect {
          klass.new(*@definition).send(:query_the_socket, "example.com", "whois.test")
        }.to raise_error(Whois::ConnectionError, "#{error}: #{error.new.message}")
      end
    end
    
    it "re-raises Errno::ECONNRESET as Whois::IncompleteResponse when allow_incomplete_responses is not true" do
      klass.any_instance.expects(:ask_the_socket).raises(Errno::ECONNRESET)
      expect {
        klass.new(*@definition).send(:query_the_socket, "example.com", "whois.test")
      }.to raise_error(Whois::IncompleteResponse, "#{Errno::ECONNRESET}: #{Errno::ECONNRESET.new.message}")
    end
    
    it "raises no errors when Errno::ECONNRESET is raised an allow_incomplete_responses is true" do
      klass.any_instance.expects(:ask_the_socket).raises(Errno::ECONNRESET)
      expect {
        klass.new(*@allow_incomplete_responses_definition).send(:query_the_socket, "example.com", "whois.test")
      }.should_not raise_error(Whois::IncompleteResponse, "#{Errno::ECONNRESET}: #{Errno::ECONNRESET.new.message}")
    end
  end

end
