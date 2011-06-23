require 'rubygems'
require 'rspec/core/rake_task'
require 'rubygems/package_task'
require 'yard'
require 'yard/rake/yardoc_task'

$:.unshift(File.dirname(__FILE__) + '/lib')
require 'whois'


# Common package properties
PKG_NAME    = ENV['PKG_NAME']    || Whois::GEM
PKG_VERSION = ENV['PKG_VERSION'] || Whois::VERSION

if ENV['SNAPSHOT'].to_i == 1
  PKG_VERSION << "." << Time.now.utc.strftime("%Y%m%d%H%M%S")
end


# Run test by default.
task :default => :rspec
task :test => :rspec

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|
  s.name              = PKG_NAME
  s.version           = PKG_VERSION
  s.summary           = "An intelligent pure Ruby WHOIS client and parser."
  s.description       = "Whois is an intelligent WHOIS client and parser written in pure Ruby. It can query registry data for IPv4, IPv6 and top level domains, parse and convert responses into easy-to-use Ruby objects."

  s.required_ruby_version = ">= 1.8.7"

  s.authors           = ["Simone Carletti"]
  s.email             = ["weppos@weppos.net"]
  s.homepage          = "http://www.ruby-whois.org"
  s.rubyforge_project = "whois"

  s.files             = %w( Rakefile LICENSE .gemtest .rspec .yardopts ) +
                        Dir.glob("*.{rdoc,gemspec}") +
                        Dir.glob("{bin,lib,spec}/**/*")
  s.executables       = ["ruby-whois"]
  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  # s.add_dependency("some_other_gem", "~> 0.1.0")

  # If your tests use any gems, include them here
  s.add_development_dependency "rake",  "~> 0.9"
  s.add_development_dependency "rspec", "~> 2.5.0"
  s.add_development_dependency "mocha"
  s.add_development_dependency "yard"
end

# This task actually builds the gem.
# We also regenerate a static .gemspec file.
Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end


# Run all the specs in the /spec folder
RSpec::Core::RakeTask.new(:rspec)


namespace :multitest do
  RUBIES = %w( ruby-1.8.7-p334 ruby-1.9.2-p180 jruby-1.6.0.RC2 ree-1.8.7-2011.03 )

  desc "Run tests for all rubies"
  task :all => :ensure_rvm do
    sh "rvm #{RUBIES.join(",")} rake test"
  end

  task :ensure_rvm do
    File.exist?(File.expand_path("~/.rvm/scripts/rvm")) || abort("RVM is not available")
  end

  RUBIES.each do |ruby|
    desc "Run tests against Ruby #{ruby}"
    task ruby => "test:ensure_rvm" do
      sh "rvm #{ruby} rake test"
    end
  end

  task :bundleize do
    sh "rvm #{RUBIES.join(",")} gem install bundler"
  end

  task :setup do
    sh "rvm #{RUBIES.join(",")} exec bundle install"
  end
end


task :clean_gemspec do
  rm "#{spec.name}.gemspec" rescue nil
end

task :clean   => [:clean_gemspec]
task :clobber => [:clobber_package]

desc "Package the library and generates the gemspec"
task :package => [:gemspec]


YARD::Rake::YardocTask.new(:yardoc) do |y|
  y.options = ["--output-dir", "yardoc"]
end

namespace :yardoc do
  desc "Publish YARD documentation to the site"
  task :publish => ["yardoc:clobber", "yardoc"] do
    ENV["username"] || raise(ArgumentError, "Missing ssh username")
    sh "rsync -avz --delete yardoc/ #{ENV["username"]}@alamak:/home/#{ENV["username"]}/ruby-whois.org/api"
  end

  desc "Remove YARD products"
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
