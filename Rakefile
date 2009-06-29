$:.unshift(File.dirname(__FILE__) + "/lib")

require 'rubygems'
require 'rake'
require 'echoe'
require 'whois'


# Common package properties
PKG_NAME    = ENV['PKG_NAME']    || Whois::GEM
PKG_VERSION = ENV['PKG_VERSION'] || Whois::VERSION
PKG_FILES   = FileList.new("{lib,test}/**/*.rb") do |files|
  files.include %w(README.rdoc CHANGELOG.rdoc LICENSE.rdoc)
  files.include %w(Rakefile)
end
RUBYFORGE_PROJECT = nil

if ENV['SNAPSHOT'].to_i == 1
  PKG_VERSION << "." << Time.now.utc.strftime("%Y%m%d%H%M%S")
end
 
 
Echoe.new(PKG_NAME, PKG_VERSION) do |p|
  p.author        = "Simone Carletti"
  p.email         = "weppos@weppos.net"
  p.summary       = "A pure Ruby WHOIS client."
  p.url           = "http://code.simonecarletti.com/whois"
  p.project       = RUBYFORGE_PROJECT

  p.need_zip      = true
  p.rdoc_pattern  = /^(lib|CHANGELOG.rdoc|README.rdoc)/

  p.development_dependencies += ["rake  ~>0.8",
                                 "echoe ~>3.1",
                                 "mocha ~>0.9"]
  #p.add_development_dependency "rake",  "~>0.8.0"
  #p.add_development_dependency "echoe", "~>3.1.0"
  #p.add_development_dependency "mocha", "~>0.9.0"

  p.rcov_options  = ["--main << README.rdoc -x Rakefile -x mocha -x rcov"]

end


begin
  require 'code_statistics'
  desc "Show library's code statistics"
  task :stats do
    CodeStatistics.new(["Whois", "lib"],
                       ["Tests", "test"]).to_s
  end
rescue LoadError
  puts "CodeStatistics (Rails) is not available"
end
