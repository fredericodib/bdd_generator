module BddGenerator
  class InstallGenerator < Rails::Generators::Base

    def create_observer_initialize_file
      template_path = File.join(File.dirname(__FILE__), './templates/observer.rb')
      template = File.read(template_path)
      create_file "config/initializers/observer.rb", template

      puts "Observers Initializer created."
    end
  end
end

