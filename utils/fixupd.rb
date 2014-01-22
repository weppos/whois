#!/usr/bin/env ruby -w

$:.unshift(File.expand_path("../../lib", __FILE__))

require 'fileutils'
require 'net/https'
require 'uri'
require 'yaml'
require 'whois'

# SOURCE = "tlds.yml"
# defs = YAML.load_file(SOURCE)


SOURCE = "https://gist.github.com/weppos/3907123/raw/tlds.yml"
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
      record = client.lookup(domain)
      part   = record.parts.first
      target = File.expand_path("../../spec/fixtures/responses/#{part.host}#{subdir}/#{name}.txt", __FILE__)
      FileUtils.mkdir_p(File.dirname(target))
      File.open(target, "w+") { |f| f.write(part.body) }
      puts "Saved #{target}"
    rescue => e
      puts "Error for #{domain}: #{e.message}"
    end
  end
end


# skippable = {}
# defs.each do |tld, node|
#   fixtures = node.reject { |k,v| k.index("_") == 0 }.reject { |k,v| node["_#{k}_skipdiff"].nil? }
#   subdir   = node["_subdir"] ? "/#{node["_subdir"]}" : ""
#   fixtures.each do |name, domain|
#     target = "spec/fixtures/responses/#{node["_server"]}#{subdir}/#{name}.txt"
#     skippable[target] = node["_#{name}_skipdiff"]
#   end
# end

# changes = `git status`.scan(/modified:\s+(.+)/).flatten
# changes.each do |path|
#   next unless (alpha = skippable[path])
#   beta = `git show HEAD~1:#{path} | diff - #{path}`.scan(/^(\d+)c\1/).flatten.map(&:to_i)
#   if (alpha - beta) == []
#     `git checkout #{path}`
#     puts "Reset #{path}"
#   end
# end
