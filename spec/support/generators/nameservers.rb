module GeneratorsNameservers

  def nameservers__when_any
    context "when any" do
      it "returns an array of Nameserver" do
        parser    = klass.new(load_part('status_registered.txt'))
        parser.nameservers.should be_a(Array)
        parser.nameservers.all? { |n| n.should be_a(Whois::Answer::Nameserver) }
      end
      it "caches the value" do
        parser    = klass.new(load_part('status_registered.txt'))
        parser.should cache_property(:nameservers)
      end
    end
  end

  def nameservers__when_none
    context "when none" do
      it "returns an empty array" do
        parser    = klass.new(load_part('status_available.txt'))
        parser.nameservers.should be_a(Array)
        parser.nameservers.should == []
      end
      it "caches the value" do
        parser    = klass.new(load_part('status_available.txt'))
        parser.should cache_property(:nameservers)
      end
    end
  end

end

RSpec.configure do |config|
  config.extend GeneratorsNameservers
end
