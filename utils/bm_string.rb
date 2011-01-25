$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'benchmark'

Benchmark.bmbm do |x|
  string = "mimas.rh.com.tr\t\t77.75.34.2"
  result = %w( mimas.rh.com.tr 77.75.34.2 )
  x.report("split & strip") do
    100_000.times do
      string.split("\s").map { |value| value.strip } == result || raise
    end
  end
  x.report("split with regexp") do
    100_000.times do
      string.split(/\s+/) == result || raise
    end
  end
end
