require 'test_helper'

class WhoisTest < Test::Unit::TestCase
  
  def test_whois
    Whois::Client.any_instance.expects(:query).with("foo.com")
    Whois.whois("foo.com")
  end
  
end