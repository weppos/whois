#!/usr/bin/env ruby -wKU

$:.unshift(File.expand_path("../../lib", __FILE__))

require 'whois'

IANAWHOIS_DIR = "~/Code/ianawhois"

servers     = {}
definitions = Whois::Server.definitions(:tld).inject({}) do |hash, item|
  hash.merge(item[0] => item[1])
end

Dir.glob("#{File.expand_path(IANAWHOIS_DIR)}/*").each do |entry|
  basename = File.basename(entry)
  next unless basename =~ /^[A-Z]+$/
  content = File.read(entry)
  server  = content =~ /^whois:\s+(.+)\n$/ && $1
  servers[".#{basename.downcase}"] = server
end

diffs = []
servers.each do |host, server|
  iana, whois = server, definitions[host]
  if iana != whois
    diffs << "#{host}: #{whois.inspect} -> #{iana.inspect}"
  end
end

puts diffs.join("\n")