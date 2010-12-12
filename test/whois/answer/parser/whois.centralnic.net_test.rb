require 'test_helper'
require 'whois/answer/parser/whois.centralnic.net'
require 'whois/answer/parser/whois.centralnic.com_test'

class AnswerParserWhoisCentralnicNetTest < AnswerParserWhoisCentralnicComTest

  def setup
    @klass  = Whois::Answer::Parser::WhoisCentralnicNet
    @host   = "whois.centralnic.com"
  end

end
