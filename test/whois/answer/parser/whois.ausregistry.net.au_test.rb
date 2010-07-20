require 'test_helper'
require 'whois/answer/parser/whois.ausregistry.net.au'
require 'whois/answer/parser/whois.audns.net.au_test'

class AnswerParserWhoisAusregistryNetAuTest < AnswerParserWhoisAudnsNetAuTest

  def setup
    @klass  = Whois::Answer::Parser::WhoisAusregistryNetAu
    @host   = "whois.audns.net.au"
  end

end
