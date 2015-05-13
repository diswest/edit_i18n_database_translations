$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "edit_i18n_database_translations/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "edit_i18n_database_translations"
  s.version     = EditI18nDatabaseTranslations::VERSION
  s.authors     = ["wwju"]
  s.email       = ["wwju@yandex.ru"]
  s.homepage    = "https://github.com/wwju/edit_i18n_database_translations"
  s.summary     = "Live editing I18n texts for content managers"
  s.description = s.summary

  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
