require 'test_helper'

class IntegrationTest < Test::Unit::TestCase

  def test_should_query_domain_and_get_answer
    with_definitions do
      Whois::Server.define(:tld, ".it", "whois.nic.it")
      Whois::Server::Adapters::Standard.any_instance.expects(:query_the_socket).with("example.it", "whois.nic.it").returns(<<-EOS)
Domain:             example.it
Status:             AVAILABLE
      EOS

      answer = Whois.query("example.it")

      assert_instance_of Whois::Answer, answer
      assert  answer.available?
      assert !answer.registered?

      assert_instance_of Whois::Answer::Parser,             answer.parser
      assert_instance_of Whois::Answer::Parser::WhoisNicIt, answer.parser.parsers.first
    end
  end

end
