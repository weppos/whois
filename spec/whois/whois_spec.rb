require 'spec_helper'

describe Whois do

  class Whois::Record::Parser::ParserTest < Whois::Record::Parser::Base
    property_supported :available? do
      eval(content_for_scanner)
    end
    property_supported :registered? do
      !available?
    end
  end

  describe ".available?" do
    it "queries the domain and returns true" do
      with_definitions do
        Whois::Server.define(:tld, ".test", "parser.test")
        Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.test", "parser.test").returns("1 == 1")

        Whois.available?("example.test").should be_true
      end
    end

    it "queries the domain and returns false" do
      with_definitions do
        Whois::Server.define(:tld, ".test", "parser.test")
        Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.test", "parser.test").returns("1 == 2")

        Whois.available?("example.test").should be_false
      end
    end

    it "returns nil when missing parser" do
      with_definitions do
        Whois::Server.define(:tld, ".test", "missing.parser.test")
        Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).returns("1 == 2")
        Whois.expects(:warn)

        Whois.available?("example.test").should be_nil
      end
    end
  end

  describe ".registered?" do
    it "queries the domain and returns false" do
      with_definitions do
        Whois::Server.define(:tld, ".test", "parser.test")
        Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.test", "parser.test").returns("1 == 1")

        Whois.registered?("example.test").should be_false
      end
    end

    it "queries the domain and returns true" do
      with_definitions do
        Whois::Server.define(:tld, ".test", "parser.test")
        Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.test", "parser.test").returns("1 == 2")

        Whois.registered?("example.test").should be_true
      end
    end

    it "returns nil when missing parser" do
      with_definitions do
        Whois::Server.define(:tld, ".test", "missing.parser.test")
        Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).returns("1 == 2")
        Whois.expects(:warn)

        Whois.registered?("example.test").should be_nil
      end
    end
  end

  describe ".lookup" do
    it "delegates the lookup to a new client" do
      client = mock()
      client.expects(:lookup).with("example.com").returns(:result)
      Whois::Client.expects(:new).returns(client)

      expect(described_class.lookup("example.com")).to eq(:result)
    end
  end
end
