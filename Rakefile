# frozen_string_literal: true

require "bundler/gem_tasks"

task default: [:test, :rubocop]


require "rspec/core/rake_task"

RSpec::Core::RakeTask.new do |t|
  t.verbose = !ENV["VERBOSE"].nil?
end

task test: :spec


require "rubocop/rake_task"

RuboCop::RakeTask.new


require "yard/rake/yardoc_task"

YARD::Rake::YardocTask.new(:yardoc) do |y|
  y.options = ["--output-dir", "yardoc"]
end

CLOBBER.include "yardoc"
