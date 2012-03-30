require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rubygems/package_task'
require 'rspec/core/rake_task'
require 'spree/core/testing_support/common_rake'

RSpec::Core::RakeTask.new

task :default => [:spec]

spec = eval(File.read('spree_digital.gemspec'))

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
end

desc "Release to gemcutter"
task :release => :package do
  require 'rake/gemcutter'
  Rake::Gemcutter::Tasks.new(spec).define
  Rake::Task['gem:push'].invoke
end

desc "Regenerates a rails 3 app for testing"
task :test_app do
  ENV['LIB_NAME'] = 'spree_digital'  
  
  require File.join `bundle show spree_core`.chomp, 'lib/generators/spree/dummy/dummy_generator.rb'
  Spree::DummyGenerator.class_eval do
    def test_dummy_add_digital
      # pulled from: http://jumph4x.net/post/20067515804/testing-spree-1-0-x-extensions-w-other-extension
      puts "Installing #{ENV['LIB_NAME']} migrations [required for testing]"
      directory File.join(`bundle show #{ENV['LIB_NAME']}`.chomp, 'db', 'migrate'), File.join(dummy_path, 'db')
    end
  end

  Rake::Task['common:test_app'].invoke
end
