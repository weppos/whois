require 'test_helper'

class IntegrationTest < Test::Unit::TestCase

  def test_should_query_domain_get_answer_load_parser_parse_response_and_return_boolean
    Whois::Server.define(:tld, ".it", "whois.nic.it")
    response = <<-EOS
Domain:             google.it
Status:             AVAILABLE
    EOS

    Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("google.it", "whois.nic.it").returns(response)
    assert Whois.available?("google.it")
  end

  def test_should_query_domain_get_answer_load_parser_parse_response
    Whois::Server.define(:tld, ".it", "whois.nic.it")
    response = <<-EOS
Domain:             google.it
Status:             AVAILABLE
    EOS

    Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("google.it", "whois.nic.it").returns(response)
    answer = Whois.query("google.it")
    assert_instance_of Whois::Answer, answer
    assert answer.available?
    assert_instance_of Whois::Answer::Parser, answer.parser
    assert_instance_of Whois::Answer::Parser::WhoisNicIt, answer.parser.parsers.first
  end

end