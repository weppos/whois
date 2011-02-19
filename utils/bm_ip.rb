$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'benchmark'
require 'rubygems'
require 'whois'

QUERIES = %w( 213.154.32.1 210.241.224.5 220.0.0.1 ) * 10

Benchmark.bmbm do |x|
  x.report("results")  do
    QUERIES.each { |s| Whois::Server.guess(s) }
  end
end
