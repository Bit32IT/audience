$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "audience/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "audience"
  s.version     = Audience::VERSION
  s.authors     = ["David Butler"]
  s.email       = ["dwbutler@ucla.edu"]
  s.homepage    = "https://www.github.com/LevoLeague/audience"
  s.summary     = "Segment an audience of users"
  s.description = "Segment your audience for targeted marketing"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.7.1"

  s.add_development_dependency "sqlite3"
end
