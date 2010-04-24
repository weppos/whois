require 'test_helper'
require 'whois/answer/parser/whois.cnnic.net.cn'

class AnswerParserWhoisCnnicNetCnTest < AnswerParserWhoisCnnicCnTest

  def setup
    @klass  = Whois::Answer::Parser::WhoisCnnicNetCn
    @host   = "whois.cnnic.cn"
  end

end
