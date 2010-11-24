require 'test_helper'
require 'whois/answer/parser/whois.hkdnr.net.hk'
require 'whois/answer/parser/whois.hkirc.hk_test'

class AnswerParserWhoisHkdnrNetHkTest < AnswerParserWhoisHkircHkTest

  def setup
    @klass  = Whois::Answer::Parser::WhoisHkdnrNetHk
    @host   = "whois.hkirc.hk"
  end

end
