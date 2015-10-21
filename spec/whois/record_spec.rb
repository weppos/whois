require 'spec_helper'

describe Whois::Record do

  subject { described_class.new(server, parts) }

  let(:server) {
    Whois::Server.factory(:tld, ".foo", "whois.example.test")
  }
  let(:parts) {[
    Whois::Record::Part.new(body: "This is a record from foo.", host: "foo.example.test"),
    Whois::Record::Part.new(body: "This is a record from bar.", host: "bar.example.test")
  ]}
  let(:content) {
    parts.map(&:body).join("\n")
  }


  describe "#initialize" do
    it "requires a server and parts" do
      expect { described_class.new }.to raise_error(ArgumentError)
      expect { described_class.new(server) }.to raise_error(ArgumentError)
      expect { described_class.new(server, parts) }.to_not raise_error
    end

    it "sets server and parts from arguments" do
      instance = described_class.new(server, parts)
      expect(instance.server).to be(server)
      expect(instance.parts).to be(parts)

      instance = described_class.new(nil, nil)
      expect(instance.server).to be_nil
      expect(instance.parts).to be_nil
    end
  end


  describe "#to_s" do
    it "delegates to #content" do
      expect(described_class.new(nil, [parts[0]]).to_s).to eq(parts[0].body)
      expect(described_class.new(nil, parts).to_s).to eq(parts.map(&:body).join("\n"))
      expect(described_class.new(nil, []).to_s).to eq("")
    end
  end

  describe "#inspect" do
    it "inspects the record content" do
      expect(described_class.new(nil, [parts[0]]).inspect).to eq(parts[0].body.inspect)
    end

    it "joins multiple parts" do
      expect(described_class.new(nil, parts).inspect).to eq(parts.map(&:body).join("\n").inspect)
    end

    it "joins empty parts" do
      expect(described_class.new(nil, []).inspect).to eq("".inspect)
    end
  end

  describe "#==" do
    it "returns true when other is the same instance" do
      one = two = described_class.new(server, parts)

      expect(one == two).to be_truthy
      expect(one.eql?(two)).to be_truthy
    end

    it "returns true when other has same class and has the same parts" do
      one, two = described_class.new(server, parts), described_class.new(server, parts)

      expect(one == two).to be_truthy
      expect(one.eql?(two)).to be_truthy
    end

    it "returns true when other has descendant class and has the same parts" do
      subklass = Class.new(described_class)
      one, two = described_class.new(server, parts), subklass.new(server, parts)

      expect(one == two).to be_truthy
      expect(one.eql?(two)).to be_truthy
    end

    it "returns true when other has same class and has equal parts" do
      one, two = described_class.new(server, parts), described_class.new(server, parts.dup)

      expect(one == two).to be_truthy
      expect(one.eql?(two)).to be_truthy
    end

    it "returns true when other has same class, different server and the same parts" do
      one, two = described_class.new(server, parts), described_class.new(nil, parts)

      expect(one == two).to be_truthy
      expect(one.eql?(two)).to be_truthy
    end

    it "returns false when other has different class and has the same parts" do
      one, two = described_class.new(server, parts), Struct.new(:server, :parts).new(server, parts)

      expect(one == two).to be_falsey
      expect(one.eql?(two)).to be_falsey
    end

    it "returns false when other has different parts" do
      one, two = described_class.new(server, parts), described_class.new(server, [])

      expect(one == two).to be_falsey
      expect(one.eql?(two)).to be_falsey
    end

    it "returns false when other is string and has the same content" do
      one, two = described_class.new(server, parts), described_class.new(server, parts).to_s

      expect(one == two).to be_falsey
      expect(one.eql?(two)).to be_falsey
    end

    it "returns false when other is string and has different content" do
      one, two = described_class.new(server, parts), "different"

      expect(one == two).to be_falsey
      expect(one.eql?(two)).to be_falsey
    end
  end


  describe "#match" do
    it "delegates to content" do
      expect(subject.match(/record/)).to be_a(MatchData)
      expect(subject.match(/record/)[0]).to eq("record")

      expect(subject.match(/nomatch/)).to be_nil
    end
  end

  describe "#match?" do
    it "calls match and checks for match" do
      expect(subject.match?(/record/)).to eq(true)
      expect(subject.match?(/nomatch/)).to eq(false)
    end
  end


  describe "#content" do
    it "returns the part body" do
      expect(described_class.new(nil, [parts[0]]).content).to eq(parts[0].body)
    end

    it "joins multiple parts" do
      expect(described_class.new(nil, parts).content).to eq(parts.map(&:body).join("\n"))
    end

    it "returns an empty string when no parts" do
      expect(described_class.new(nil, []).content).to eq("")
    end
  end

end
