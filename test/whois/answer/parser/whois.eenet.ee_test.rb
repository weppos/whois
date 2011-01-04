require 'test_helper'
require 'whois/answer/parser/whois.eenet.ee'
require 'whois/answer/parser/whois.tld.ee_test'

class AnswerParserWhoisEenetEeTest < AnswerParserWhoisTldEeTest

  def setup
    @klass  = Whois::Answer::Parser::WhoisEenetEe
    @host   = "whois.tld.ee"
  end

end
