#!/usr/bin/env ruby -w

$:.unshift(File.expand_path("../../lib", __FILE__))

require 'fileutils'
require 'whois'
begin
  require File.expand_path("../whois-utf8", __FILE__)
rescue LoadError
end

d = ARGV.shift || raise("Missing domain")
n = ARGV.shift || raise("Missing file name")

r = Whois.lookup(d)

r.parts.each do |part|
  target = File.expand_path("../../spec/fixtures/responses/#{part.host}/#{n}.txt", __FILE__)
  FileUtils.mkdir_p(File.dirname(target))
  File.open(target, "w+") { |f| f.write(part.body) }
  puts "#{target}"
end
