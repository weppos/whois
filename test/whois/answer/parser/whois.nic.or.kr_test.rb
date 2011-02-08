require 'test_helper'
require 'whois/answer/parser/whois.nic.or.kr'
require 'whois/answer/parser/whois.kr_test'

class AnswerParserWhoisNicOrKrTest < AnswerParserWhoisKrTest

  def setup
    @klass  = Whois::Answer::Parser::WhoisNicOrKr
    @host   = "whois.kr"
  end

end
