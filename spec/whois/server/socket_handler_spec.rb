require 'spec_helper'
require 'whois/server/socket_handler'

describe Whois::Server::SocketHandler do

  describe "#call" do
    [ Errno::ECONNRESET, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::EPIPE, SocketError ].each do |error|
      it "re-raises #{error} as Whois::ConnectionError" do
        expect(subject).to receive(:execute).and_raise(error)
        expect {
          subject.call("example.test", "whois.test", 43)
        }.to raise_error(Whois::ConnectionError, "#{error}: #{error.new.message}")
      end

      it "executes a socket connection for given args" do
        socket = double("Handler")
        expect(socket).to receive(:write).with("example.test\r\n")
        expect(socket).to receive(:read)
        expect(socket).to receive(:close)

        expect(TCPSocket).to receive(:new).with("whois.test", 43).and_return(socket)
        subject.call("example.test", "whois.test", 43)
      end
    end
  end

end
