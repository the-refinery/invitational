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
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "cancancan"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "capybara", "~> 2.0.2"
  s.add_development_dependency "combustion"
  s.add_development_dependency "rspec", "~> 2.12.0"
  s.add_development_dependency "rspec-rails", "~> 2.12.0"
  s.add_development_dependency "rspec-given", "~> 2.3.0"
end
