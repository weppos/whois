#!/usr/bin/env ruby -w

# Usage:
#
# $ ./utils/mkwhois.rb google.com.br status_registered
#
# It will execute the query and dump the result into a file
# called status_registered.txt into the appriate folder based
# on the hostname that was queried, and the TLD.

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
tld = r.server.allocation

r.parts.each do |part|
  target = File.expand_path("../../spec/fixtures/responses/#{part.host}/#{tld}/#{n}.txt", __FILE__)
  FileUtils.mkdir_p(File.dirname(target))
  File.open(target, "w+") { |f| f.write(part.body) }
  puts "#{target}"
end
