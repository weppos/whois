$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'benchmark'


Benchmark.bmbm do |x|
  string = File.read(File.expand_path("../../spec/fixtures/responses/whois.nic.tr/status_registered.txt", __FILE__))
  result = "2010-Aug-22."
  x.report("w/i delimiter") do
    100_000.times do
      string =~ /^Expires on\.+:\s+(.+)\n/
      $1 == result || raise
    end
  end
  x.report("w/o delimiter") do
    100_000.times do
      string =~ /Expires on\.+:\s+(.+)\n/
      $1 == result || raise
    end
  end
end
