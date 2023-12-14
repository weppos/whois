# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "whois/version"

Gem::Specification.new do |s|
  s.name        = "whois"
  s.version     = Whois::VERSION
  s.authors     = ["Simone Carletti"]
  s.email       = ["weppos@weppos.net"]
  s.homepage    = "https://whoisrb.org/"
  s.summary     = "An intelligent pure Ruby WHOIS client and parser."
  s.description = "Whois is an intelligent WHOIS client and parser written in pure Ruby. It can query registry data for IPv4, IPv6 and top level domains, and parse the responses into easy-to-use Ruby objects via the whois-parser library."
  s.license     = "MIT"

  s.required_ruby_version = ">= 3.0"

  s.require_paths    = %w( lib )
  s.executables      =%w( whoisrb )
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = %w( LICENSE.txt .yardopts )

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "yard"
end
