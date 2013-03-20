RSpec::Matchers.define :support_property do |property|
  match_unless_raises Whois::AttributeNotSupported do |parser|
    parser.send(property)
  end
end
