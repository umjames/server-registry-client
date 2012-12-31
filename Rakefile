#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:test) do |t|
	t.rspec_opts = "--color --format nested --backtrace"
end

# desc "Run all tests"
# task :test do |t|
# 	sh %{ ruby -S rspec --color --format nested --backtrace }
# end