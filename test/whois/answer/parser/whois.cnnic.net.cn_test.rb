require 'test_helper'
require 'whois/answer/parser/whois.cnnic.net.cn'
require 'whois/answer/parser/whois.cnnic.cn_test'

class AnswerParserWhoisCnnicNetCnTest < AnswerParserWhoisCnnicCnTest

  def setup
    @klass  = Whois::Answer::Parser::WhoisCnnicNetCn
    @host   = "whois.cnnic.cn"
  end

end
