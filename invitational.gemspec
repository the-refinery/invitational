$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "invitational/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "invitational"
  s.version     = Invitational::VERSION
  s.authors     = ["Joe Fiorini", "Dave Goerlich"]
  s.email       = ["joe@d-i.co", "dave@d-i.co"]
  s.homepage    = "http://github.com/d-i/invitational"
  s.summary     = "Manage users and the objects they belong to"
  s.description = "See summary"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "cancan"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "capybara", "~> 2.0.2"
  s.add_development_dependency "combustion"
  s.add_development_dependency "rspec", "~> 2.12.0"
  s.add_development_dependency "rspec-rails", "~> 2.12.0"
  s.add_development_dependency "rspec-given", "~> 2.3.0"
end
