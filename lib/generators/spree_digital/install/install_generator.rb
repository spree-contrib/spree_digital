module SpreeDigital
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: true
      class_option :seed, type: :boolean, default: true, banner: 'load seed data (migrations must be run)'

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_digital'
      end

      def run_migrations
        if options[:auto_run_migrations] || options[:seed]
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end

      def include_seed_data
        append_file 'db/seeds.rb', <<-SEEDS.strip_heredoc
          SpreeDigital::Engine.load_seed if defined?(SpreeDigital)
        SEEDS
      end

      def populate_seed_data
        if options[:seed]
          say_status :loading, 'seed data'
          cmd = -> { rake('db:seed') }
          cmd.call
        else
          say_status :skipping, 'seed data (you can always run rake db:seed)'
        end
      end
    end
  end
end
