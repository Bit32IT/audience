module Audience
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def create_initializer_file
      create_file 'config/initializers/audience.rb', ''
    end

    def create_application_segment
      copy_file 'application_segment.rb', 'app/segments/application_segment.rb'
    end
  end
end
