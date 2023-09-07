$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "invitational/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "invitational"
  s.version     = Invitational::VERSION
  s.authors     = ["Dave Goerlich"]
  s.email       = ["dave@d-i.co"]
  s.homepage    = "http://github.com/the-refinery/invitational"
  s.summary     = "Solution that eliminates the tight coupling between user identity/authentication and application functional authorization"
  s.description = "Solution that eliminates the tight coupling between user identity/authentication and application functional authorization"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["{spec}/**/*"]

  s.add_dependency "rails", "> 4.0"
  s.add_dependency "cancancan", "~> 3.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "combustion"
  s.add_development_dependency "capybara"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-given"
end
