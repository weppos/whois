require 'rubygems'

$:.unshift(File.dirname(__FILE__) + '/lib')
require 'whois'


# Run test by default.
task :default => :spec
task :test => :spec

spec = Gem::Specification.new do |s|
  s.name              = "whois"
  s.version           = Whois::VERSION
  s.summary           = "An intelligent pure Ruby WHOIS client and parser."
  s.description       = "Whois is an intelligent WHOIS client and parser written in pure Ruby. It can query registry data for IPv4, IPv6 and top level domains, parse and convert responses into easy-to-use Ruby objects."

  s.required_ruby_version = ">= 1.9.2"

  s.authors           = ["Simone Carletti"]
  s.email             = ["weppos@weppos.net"]
  s.homepage          = "http://www.ruby-whois.org/"
  s.license           = "MIT"
  s.rubyforge_project = "whois"

  s.files             = %w( LICENSE.txt .yardopts ) +
                        Dir.glob("*.{md,gemspec}") +
                        Dir.glob("{bin,data,lib}/**/*")
  s.executables       = %w( ruby-whois )
  s.require_paths     = %w( lib )

  s.add_dependency "activesupport", ">= 3"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.0"
  s.add_development_dependency "mocha"
  s.add_development_dependency "yard"

  s.post_install_message = <<EOS
********************************************************************************

  Thank you for installing the whois gem!

  If you like this gem, please support the project.
  http://pledgie.com/campaigns/11383

  Does your project or organization use this gem? Add it to the apps wiki.
  https://github.com/weppos/whois/wiki/apps

  Are you looking for a quick and convenient way to perform WHOIS queries?
  Check out RoboWhois WHOIS API.
  https://www.robowhois.com/

********************************************************************************
EOS
end


require 'rubygems/package_task'

Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

desc "Remove any temporary products, including gemspec"
task :clean => [:clobber] do
  rm "#{spec.name}.gemspec" if File.file?("#{spec.name}.gemspec")
end

desc "Remove any generated file"
task :clobber => [:clobber_package]

desc "Package the library and generates the gemspec"
task :package => [:gemspec]


require 'rspec/core/rake_task'
begin
  require 'fuubar'
rescue LoadError
end

RSpec::Core::RakeTask.new do |t|
  t.verbose = !!ENV["VERBOSE"]
  t.rspec_opts  = []
  t.rspec_opts << ['--format', 'Fuubar'] if defined?(Fuubar)
end


require 'yard'

YARD::Rake::YardocTask.new(:yardoc) do |y|
  y.options = ["--output-dir", "yardoc"]
end

namespace :yardoc do
  task :clobber do
    rm_r "yardoc" rescue nil
  end
end

task :clobber => "yardoc:clobber"


desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r whois.rb"
end


Dir["tasks/**/*.rake"].each do |file|
  load(file)
end
