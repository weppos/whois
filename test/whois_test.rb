require 'test_helper'

class WhoisTest < Test::Unit::TestCase

  class Whois::Answer::Parser::ParserTest < Whois::Answer::Parser::Base
    property_supported :available? do
      eval(content_for_scanner)
    end
    property_supported :registered? do
      !available?
    end
  end

  def test_available_should_query_domain_and_return_true
    with_definitions do
      Whois::Server.define(:tld, ".test", "parser.test")
      Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.test", "parser.test").returns("1 == 1")

      assert  Whois.available?("example.test")
    end
  end

  def test_available_should_query_domain_and_return_false
    with_definitions do
      Whois::Server.define(:tld, ".test", "parser.test")
      Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.test", "parser.test").returns("1 == 2")

      assert !Whois.available?("example.test")
    end
  end

  def test_available_with_missing_parser_should_return_nil
    with_definitions do
      Whois::Server.define(:tld, ".test", "missing.parser.test")
      Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).returns("1 == 2")

      assert_nil Whois.available?("example.test")
    end
  end


  def test_registered_should_query_domain_and_return_true
    with_definitions do
      Whois::Server.define(:tld, ".test", "parser.test")
      Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.test", "parser.test").returns("1 == 1")

      assert !Whois.registered?("example.test")
    end
  end

  def test_registered_should_query_domain_and_return_false
    with_definitions do
      Whois::Server.define(:tld, ".test", "parser.test")
      Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.test", "parser.test").returns("1 == 2")

      assert  Whois.registered?("example.test")
    end
  end

  def test_registered_with_missing_parser_should_return_nil
    with_definitions do
      Whois::Server.define(:tld, ".test", "missing.parser.test")
      Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).returns("1 == 2")

      assert_nil Whois.registered?("example.test")
    end
  end

end
