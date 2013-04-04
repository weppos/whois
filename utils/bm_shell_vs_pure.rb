$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'benchmark'
require 'whois'

DOMAINS = %w(weppos.it) * 5

Benchmark.bmbm do |x|
  x.report("shell") do
    DOMAINS.each { |d| `whois #{d}` }
  end
  x.report("pure")  do
    DOMAINS.each { |d| Whois::Client.new.lookup(d) }
  end
end
