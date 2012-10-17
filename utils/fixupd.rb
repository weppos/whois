#!/usr/bin/env ruby -wKU

$:.unshift(File.expand_path("../../lib", __FILE__))

require 'fileutils'
require 'net/https'
require 'uri'
require 'yaml'
require 'whois'

SOURCE = "https://raw.github.com/gist/3907123/tlds.yml"

uri  = URI.parse(SOURCE)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE # read into this
defs = YAML.load(http.get(uri.request_uri).body)

client = Whois::Client.new

defs.each do |tld, node|
  fixtures = node.reject { |k,v| k.index("_") == 0 }
  subdir   = node["_subdir"] ? "/#{node["_subdir"]}" : ""
  fixtures.each do |name, domain|
    begin
      record = client.query(domain)
      part   = record.parts.first
      target = File.expand_path("../../spec/fixtures/responses/#{part.host}#{subdir}/#{name}.txt", __FILE__)
      FileUtils.mkdir_p(File.dirname(target))
      File.open(target, "w+") { |f| f.write(part.body) }
      puts "Saved #{target}"
    rescue => e
      puts "Error #{e.message}"
    end
  end
end
