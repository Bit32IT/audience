module Audience
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      app.config.paths.add 'app/segments', eager_load: true
    end
  end
end
