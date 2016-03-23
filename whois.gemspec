# -*- encoding: utf-8 -*-
# stub: whois 4.0.0.pre.beta1 ruby lib

Gem::Specification.new do |s|
  s.name = "whois"
  s.version = "4.0.0.pre.beta1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Simone Carletti"]
  s.date = "2016-03-23"
  s.description = "Whois is an intelligent WHOIS client and parser written in pure Ruby. It can query registry data for IPv4, IPv6 and top level domains, parse and convert responses into easy-to-use Ruby objects."
  s.email = ["weppos@weppos.net"]
  s.executables = ["whoisrb"]
  s.files = [".yardopts", "CHANGELOG.md", "CONTRIBUTING.md", "LICENSE.txt", "README.md", "bin/whoisrb", "data/asn16.json", "data/asn32.json", "data/ipv4.json", "data/ipv6.json", "data/tld.json", "lib/whois.rb", "lib/whois/client.rb", "lib/whois/errors.rb", "lib/whois/record.rb", "lib/whois/record/part.rb", "lib/whois/server.rb", "lib/whois/server/adapters/afilias.rb", "lib/whois/server/adapters/arin.rb", "lib/whois/server/adapters/arpa.rb", "lib/whois/server/adapters/base.rb", "lib/whois/server/adapters/formatted.rb", "lib/whois/server/adapters/none.rb", "lib/whois/server/adapters/not_implemented.rb", "lib/whois/server/adapters/standard.rb", "lib/whois/server/adapters/verisign.rb", "lib/whois/server/adapters/web.rb", "lib/whois/server/socket_handler.rb", "lib/whois/version.rb", "whois.gemspec"]
  s.homepage = "http://whoisrb.org/"
  s.licenses = ["MIT"]
  s.post_install_message = "********************************************************************************\n\n  Thank you for installing the whois gem!\n\n  If you like this gem, please support the project.\n  http://pledgie.com/campaigns/11383\n\n  Does your project or organization use this gem? Add it to the apps wiki.\n  https://github.com/weppos/whois/wiki/apps\n\n********************************************************************************\n"
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.rubygems_version = "2.5.1"
  s.summary = "An intelligent pure Ruby WHOIS client and parser."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
