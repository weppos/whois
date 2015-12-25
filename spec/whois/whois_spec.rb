require 'spec_helper'

describe Whois do

  describe ".lookup" do
    it "delegates the lookup to a new client" do
      client = double()
      expect(client).to receive(:lookup).with("example.com").and_return(:result)
      expect(Whois::Client).to receive(:new).and_return(client)

      expect(described_class.lookup("example.com")).to eq(:result)
    end
  end

end
