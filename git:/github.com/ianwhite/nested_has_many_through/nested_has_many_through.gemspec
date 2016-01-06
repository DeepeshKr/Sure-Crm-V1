$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nested_has_many_through/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nested_has_many_through"
  s.version     = NestedHasManyThrough::VERSION
  s.authors     = ["deepesh"]
  s.email       = ["deepesh.krishnan@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of NestedHasManyThrough."
  s.description = "TODO: Description of NestedHasManyThrough."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3"
end
