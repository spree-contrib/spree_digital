namespace :spree_digital do
  
  desc "Copies all migrations (NOTE: This will be obsolete with Rails 3.1)"
  task :install do
    Rake::Task['spree_digital:install:migrations'].invoke
  end

  namespace :install do

    desc "Copies all migrations (NOTE: This will be obsolete with Rails 3.1)"
    task :migrations do
      source = File.join(File.dirname(__FILE__), '..', '..', 'db')
      destination = File.join(Rails.root, 'db')
      Spree::FileUtilz.mirror_files(source, destination)
    end

  end
end