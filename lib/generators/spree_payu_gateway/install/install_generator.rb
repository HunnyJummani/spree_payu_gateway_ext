module SpreePayuGateway
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false


      def self.source_root
        @_config_source_root ||= File.expand_path("../", __FILE__)
      end


      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_payu_gateway'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask('Would you like to run the migrations now? [Y/n]'))
        if run_migrations
          run 'bundle exec rails db:migrate'
        else
          puts 'Skipping rails db:migrate, don\'t forget to run it!'
        end
      end

      # def install_config_gem
      #   run 'bundle exec rails g config:install'
      #   copy_file 'development.yml', 'config/settings/development.yml', force: true
      #   copy_file 'production.yml', 'config/settings/production.yml', force: true
      #   copy_file 'test.yml', 'config/settings/test.yml', force: true
      # end
    end
  end
end
