require 'spec_helper'
require 'whois/record/handle'

describe Whois::Record::Handle do

  describe '#initialize' do
    it 'takes a format' do
      expect {
        instance = described_class.new('rpsl', :domain, {})
        expect(instance.format).to eq('rpsl')
      }.to_not raise_error
    end

    it 'takes a handle type' do
      expect {
        instance = described_class.new('rpsl', :domain, {})
        expect(instance.handle_type).to eq('domain')
      }.to_not raise_error
    end

    it 'raises HandleTypeNotImplemented if handle type is not implemented' do
      expect {
        instance = described_class.new('rpsl', :nice_but_unknown_handle, {})
        expect(instance.handle_type).to eq('nice_but_unknown_handle')
      }.to raise_error(Whois::HandleTypeNotImplemented)
    end

    it 'raises HandleFormatNotImplemented if format is not implemented' do
      expect {
        instance = described_class.new('nice_but_unknown_format', :domain, {})
        expect(instance.format).to eq('nice_but_unknown_format')
      }.to raise_error(Whois::HandleFormatNotImplemented)
    end
  end
end
