require "spec_helper"

describe Whois do

  class Whois::Answer::Parser::ParserTest < Whois::Answer::Parser::Base
    property_supported :available? do
      eval(content_for_scanner)
    end
    property_supported :registered? do
      !available?
    end
  end

  describe ".available?" do
    it "should query domain and return true" do
      with_definitions do
        Whois::Server.define(:tld, ".test", "parser.test")
        Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.test", "parser.test").returns("1 == 1")

        Whois.available?("example.test").should be_true
      end
    end

    it "should query domain and return false" do
      with_definitions do
        Whois::Server.define(:tld, ".test", "parser.test")
        Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.test", "parser.test").returns("1 == 2")

        Whois.available?("example.test").should be_false
      end
    end

    it "should return nil with missing parser" do
      with_definitions do
        Whois::Server.define(:tld, ".test", "missing.parser.test")
        Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).returns("1 == 2")

        Whois.available?("example.test").should be_nil
      end
    end
  end

  describe ".registered?" do
    it "should query domain and return false" do
      with_definitions do
        Whois::Server.define(:tld, ".test", "parser.test")
        Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.test", "parser.test").returns("1 == 1")

        Whois.registered?("example.test").should be_false
      end
    end

    it "should query domain and return true" do
      with_definitions do
        Whois::Server.define(:tld, ".test", "parser.test")
        Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.test", "parser.test").returns("1 == 2")

        Whois.registered?("example.test").should be_true
      end
    end

    it "should return nil with missing parser" do
      with_definitions do
        Whois::Server.define(:tld, ".test", "missing.parser.test")
        Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).returns("1 == 2")

        Whois.registered?("example.test").should be_nil
      end
    end
  end

end
