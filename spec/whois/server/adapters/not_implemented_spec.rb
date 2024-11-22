# frozen_string_literal: true

require "spec_helper"

describe Whois::Server::Adapters::NotImplemented do
  before do
    @definition = [:ipv6, "2001:0000::/32", "teredo", { adapter: described_class }]
  end


  describe "#lookup" do
    it "raises Whois::ServerNotImplemented" do
      expect {
        described_class.new(*@definition).lookup("example.test")
      }.to raise_error(Whois::ServerNotImplemented)
    end

    it "customizes the error message according to the host" do
      expect {
        described_class.new(*@definition).lookup("example.test")
      }.to raise_error(Whois::ServerNotImplemented, /teredo/)
    end
  end
end
