# -*- encoding: utf-8 -*-
# stub: whois 4.0.7 ruby lib

Gem::Specification.new do |s|
  s.name = "whois".freeze
  s.version = "4.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Simone Carletti".freeze]
  s.date = "2018-07-19"
  s.description = "Whois is an intelligent WHOIS client and parser written in pure Ruby. It can query registry data for IPv4, IPv6 and top level domains, and parse the responses into easy-to-use Ruby objects via the whois-parser library.".freeze
  s.email = ["weppos@weppos.net".freeze]
  s.executables = ["whoisrb".freeze]
  s.files = [".yardopts".freeze, "4.0-Upgrade.md".freeze, "CHANGELOG.md".freeze, "CONTRIBUTING.md".freeze, "LICENSE.txt".freeze, "README.md".freeze, "bin/console".freeze, "bin/setup".freeze, "bin/whoisrb".freeze, "data/asn16.json".freeze, "data/asn32.json".freeze, "data/ipv4.json".freeze, "data/ipv6.json".freeze, "data/tld.json".freeze, "lib/whois.rb".freeze, "lib/whois/client.rb".freeze, "lib/whois/errors.rb".freeze, "lib/whois/record.rb".freeze, "lib/whois/record/part.rb".freeze, "lib/whois/server.rb".freeze, "lib/whois/server/adapters/afilias.rb".freeze, "lib/whois/server/adapters/arin.rb".freeze, "lib/whois/server/adapters/arpa.rb".freeze, "lib/whois/server/adapters/base.rb".freeze, "lib/whois/server/adapters/formatted.rb".freeze, "lib/whois/server/adapters/none.rb".freeze, "lib/whois/server/adapters/not_implemented.rb".freeze, "lib/whois/server/adapters/standard.rb".freeze, "lib/whois/server/adapters/verisign.rb".freeze, "lib/whois/server/adapters/web.rb".freeze, "lib/whois/server/socket_handler.rb".freeze, "lib/whois/version.rb".freeze, "whois.gemspec".freeze]
  s.homepage = "https://whoisrb.org/".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "2.7.3".freeze
  s.summary = "An intelligent pure Ruby WHOIS client and parser.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<yard>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<yard>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<yard>.freeze, [">= 0"])
  end
end
