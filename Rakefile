require "rubygems"
require "rake/testtask"
require "rake/gempackagetask"
begin
  require "hanna/rdoctask"
rescue LoadError
  require "rake/rdoctask"
end

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
task :default => ["test"]

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|

  s.name              = PKG_NAME
  s.version           = PKG_VERSION
  s.summary           = "An intelligent pure Ruby WHOIS client and parser."
  s.author            = "Simone Carletti"
  s.email             = "weppos@weppos.net"
  s.homepage          = "http://www.ruby-whois.org"
  s.description       = <<-EOD
    Whois is an intelligent WHOIS client and parser written in pure Ruby. \
    It can query registry data for IPv4, IPv6 and top level domains, \
    parse and convert responses into easy-to-use Ruby objects.
  EOD
  s.rubyforge_project = RUBYFORGE_PROJECT

  s.has_rdoc          = true
  # You should probably have a README of some kind. Change the filename
  # as appropriate
  s.extra_rdoc_files  = Dir.glob("*.rdoc")
  s.rdoc_options      = %w(--main README.rdoc)

  # Add any extra files to include in the gem (like your README)
  s.files             = %w() + Dir.glob("*.{rdoc,gemspec}") + Dir.glob("{bin,lib}/**/*")
  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  # s.add_dependency("some_other_gem", "~> 0.1.0")

  # If your tests use any gems, include them here
  s.add_development_dependency("mocha")
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


# Generate documentation
Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("*.rdoc", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

# Run all the tests in the /test folder
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

task "ensure_rvm" do
  raise "RVM is not available" unless File.exist?(File.expand_path("~/.rvm/scripts/rvm"))
end

RUBIES = %w(1.8.6-p399 1.8.7-p249 1.9.1-p378 1.9.2-rc2 rbx-1.0.1-20100603 jruby-1.5.1 ree-1.8.7-2010.02)

desc "Run tests for all rubies"
task "test_rubies" => "ensure_rvm" do
  sh "rvm #{RUBIES.join(",")} rake test"
end

RUBIES.each do |ruby|
  desc "Run tests on Ruby #{ruby}"
  task "test_ruby_#{ruby}"=> "ensure_rvm" do
    sh "rvm #{ruby} rake test"
  end
end


desc "Remove any temporary products, including gemspec"
task :clean => [:clobber] do
  rm "#{spec.name}.gemspec" if File.file?("#{spec.name}.gemspec")
end

desc "Remove any generated file"
task :clobber => [:clobber_rdoc, :clobber_rcov, :clobber_package]

desc "Package the library and generates the gemspec"
task :package => [:gemspec]

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

begin
  require "code_statistics"
  desc "Show library's code statistics"
  task :stats do
    CodeStatistics.new(["Public Suffix Service", "lib"],
                       ["Tests", "test"]).to_s
  end
rescue LoadError
  # puts "CodeStatistics (Rails) is not available"
end

namespace :rdoc do
  desc "Publish RDoc documentation to the site"
  task :publish => [:clobber_rdoc, :rdoc] do
    sh "rsync -avz --delete rdoc/ weppos@dads:/home/weppos/ruby-whois.org/api"
  end
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r whois.rb"
end


Dir["tasks/**/*.rake"].each do |file|
  load(file)
end
