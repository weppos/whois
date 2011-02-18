module ParserExampleGroup

  def load_part(path)
    part(File.read(fixture("responses", @host.to_s, @suffix.to_s, @schema.to_s, path)), @host)
  end

  def part(*args)
    Whois::Answer::Part.new(*args)
  end

end

RSpec::Matchers.define :support_property_and_cache do |property, expected|
  match do |instance|
    cache = instance.instance_variable_get(:"@cached_properties")
    instance.send(property).should == expected
    cache.key?(property).should be_true
    instance.send(property).should == expected
  end
end

RSpec::configure do |c|
  def c.escaped_path(*parts)
    Regexp.compile(parts.join('[\\\/]'))
  end

  c.include ParserExampleGroup, :type => :controller, :example_group => {
    :file_path => c.escaped_path(%w( spec whois answer parser ))
  }
end
