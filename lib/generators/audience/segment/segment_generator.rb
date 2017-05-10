module Audience
  class SegmentGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def create_segment
      template 'segment.rb', File.join("app/segments", class_path, "#{file_name}_segment.rb")
    end

    def register_segment
      append_file 'config/initializers/audience.rb', "Audience.register_segment(:#{file_name}, #{class_name}Segment.new)\n"
    end
  end
end
