require 'test_helper'
require 'whois/answer/parser/saudinic.net.sa'
require 'whois/answer/parser/whois.nic.net.sa_test'

class AnswerParserSaudinicNetSaTest < AnswerParserWhoisNicNetSaTest

  def setup
    @klass  = Whois::Answer::Parser::SaudinicNetSa
    @host   = "whois.nic.net.sa"
  end

end
