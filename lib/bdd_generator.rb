module BddGenerator
  class InstallGenerator < Rails::Generators::Base

    def create_aspects_initialize_file
      template_path = File.join(File.dirname(__FILE__), './templates/aspects.rb')
      template = File.read(template_path)
      create_file "config/initializers/aspects.rb", template
    end

    def create_bdd_generator_parser_initialize_file
      template_path = File.join(File.dirname(__FILE__), './templates/bdd_generator_parser.rb')
      template = File.read(template_path)
      create_file "lib/bdd_generator_parser.rb", template
    end

    def create_bdd_generator_initialize_file
      template_path = File.join(File.dirname(__FILE__), './templates/bdd_generator.rake')
      template = File.read(template_path)
      create_file "lib/tasks/bdd_generator.rake", template
    end

    def create_bdd_generator_steps_initialize_file
      template_path = File.join(File.dirname(__FILE__), './templates/bdd_generator_steps.rb')
      template = File.read(template_path)
      create_file "features/step_definitions/bdd_generator_steps.rb", template
    end
  end
end

