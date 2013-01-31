#!/usr/bin/env ruby -wKU

$:.unshift(File.expand_path("../../lib", __FILE__))

require 'fileutils'
require 'whois'
require 'json'

def convert(type)
  defs = Whois::Server.definitions(type)
  json = {}
  defs.each do |(allocation, host, options)|
    json[allocation] = { host: host }
    json[allocation].merge!(options)
  end

  JSON.pretty_generate(json)
end

def write(type, content)
  File.open(File.expand_path("../../lib/whois/definitions/#{type}.json", __FILE__), "w+") do |f|
    f.write(content)
  end
end


Whois::Server.definitions.keys.each do |type|
  write(type, convert(type))
end
