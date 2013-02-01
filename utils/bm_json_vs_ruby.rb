$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'whois'
require 'benchmark'


Benchmark.bmbm do |x|
  x.report("JSON definitions single load") do
    Whois::Server.load_definitions(:json)
  end
  x.report("Ruby definitions single load") do
    Whois::Server.load_definitions(:ruby)
  end
  x.report("JSON definitions") do
    1_000.times do
      Whois::Server.load_definitions(:json)
      Whois::Server.definitions.clear
    end
  end
  x.report("Ruby definitions") do
    1_000.times do
      Whois::Server.load_definitions(:ruby)
      Whois::Server.definitions.clear
    end
  end
end
