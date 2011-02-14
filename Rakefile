require "rubygems"
require "rake/testtask"
require "rspec/core/rake_task"
require "rake/gempackagetask"

$:.unshift(File.dirname(__FILE__) + "/lib")
require "whois"


# Common package properties
PKG_NAME    = ENV['PKG_NAME']    || Whois::GEM
PKG_VERSION = ENV['PKG_VERSION'] || Whois::VERSION
RUBYFORGE_PROJECT = "whois"

if ENV['SNAPSHOT'].to_i == 1
  PKG_VERSION << "." << Time.now.utc.strftime("%Y%m%d%H%M%S")
end


# Run test by default.
task :default => :test
task :test => [:rspec, :testunit]

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|
  s.name              = PKG_NAME
  s.version           = PKG_VERSION
  s.summary           = "An intelligent pure Ruby WHOIS client and parser."
  s.description       = <<-EOD
    Whois is an intelligent WHOIS client and parser written in pure Ruby. \
    It can query registry data for IPv4, IPv6 and top level domains, \
    parse and convert responses into easy-to-use Ruby objects.
  EOD

  s.required_ruby_version = ">= 1.8.7"

  s.author            = "Simone Carletti"
  s.email             = "weppos@weppos.net"
  s.homepage          = "http://www.ruby-whois.org"
  s.rubyforge_project = RUBYFORGE_PROJECT

  s.has_rdoc          = true
  s.extra_rdoc_files  = Dir.glob("*.rdoc")
  s.rdoc_options      = %w( --main README.rdoc )

  s.files             = %w( Rakefile LICENSE .gemtest .rspec .yardopts ) +
                        Dir.glob("*.{rdoc,gemspec}") +
                        Dir.glob("{bin,lib,test,spec}/**/*")
  s.executables       = ["ruby-whois"]
  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  # s.add_dependency("some_other_gem", "~> 0.1.0")

  # If your tests use any gems, include them here
  s.add_development_dependency("rspec", "~> 2.5.0")
  s.add_development_dependency("mocha")
  s.add_development_dependency("yard")
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end


# Run all the specs in the /spec folder
RSpec::Core::RakeTask.new(:rspec)

# Run all the tests in the /test folder
Rake::TestTask.new(:testunit) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end


namespace :test do
  RUBIES = %w( 1.8.7-p330 1.9.2-p0 jruby-1.5.6 ree-1.8.7-2010.02 )

  desc "Run tests for all rubies"
  task :rubies => :ensure_rvm do
    sh "rvm #{RUBIES.join(",")} rake default"
  end

  task :ensure_rvm do
    File.exist?(File.expand_path("~/.rvm/scripts/rvm")) || abort("RVM is not available")
  end

  namespace :ruby do
    RUBIES.each do |ruby|
      desc "Run tests against Ruby #{ruby}"
      task ruby => "test:ensure_rvm" do
        sh "rvm #{ruby} rake default"
      end
    end
  end
end


desc "Remove any temporary products, including gemspec"
task :clean => [:clobber] do
  rm "#{spec.name}.gemspec" if File.file?("#{spec.name}.gemspec")
end

desc "Remove any generated file"
task :clobber => [:clobber_rcov, :clobber_package]

desc "Package the library and generates the gemspec"
task :package => [:gemspec]


begin
  require "yard"
  require "yard/rake/yardoc_task"

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
rescue LoadError
  puts "YARD is not available"
end


begin
  require "rcov/rcovtask"

  desc "Create a code coverage report"
  Rcov::RcovTask.new do |t|
    t.test_files = FileList["test/**/*_test.rb"]
    t.ruby_opts << "-Itest -x mocha,rcov,Rakefile"
    t.verbose = true
  end
rescue LoadError
  task :clobber_rcov
  # puts "RCov is not available"
end


desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r whois.rb"
end


Dir["tasks/**/*.rake"].each do |file|
  load(file)
end
