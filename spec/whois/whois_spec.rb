require 'spec_helper'

describe Whois do

  describe ".lookup" do
    it "delegates the lookup to a new client" do
      client = mock()
      client.expects(:lookup).with("example.com").returns(:result)
      Whois::Client.expects(:new).returns(client)

      expect(described_class.lookup("example.com")).to eq(:result)
    end
  end

end
