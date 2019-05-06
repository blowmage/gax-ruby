# -*- ruby -*-
# encoding: utf-8

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "google/gax/version"

Gem::Specification.new do |gem|
  gem.name = "google-gax"
  gem.version = Google::Gax::VERSION
  gem.authors = ["Google API Authors"]
  gem.email = "googleapis-packages@google.com"
  gem.homepage = "https://github.com/googleapis/gax-ruby"
  gem.summary = "Aids the development of APIs for clients and servers based"
  gem.summary += " on GRPC and Google APIs conventions"
  gem.description = "Google API Extensions"
  gem.files = %w[Rakefile README.md]
  gem.files += Dir.glob "lib/**/*"
  gem.files += Dir.glob "spec/**/*"
  gem.require_paths = %w[lib]
  gem.platform = Gem::Platform::RUBY
  gem.license = "BSD-3-Clause"

  gem.required_ruby_version = ">= 2.3.0"

  gem.add_dependency "google-protobuf", "~> 3.2"
  gem.add_dependency "googleapis-common-protos", ">= 1.3.5", "< 2.0"
  gem.add_dependency "googleauth", ">= 0.6.2", "< 0.10.0"
  gem.add_dependency "grpc", ">= 1.7.2", "< 2.0"

  gem.add_development_dependency "codecov", "~> 0.1"
  gem.add_development_dependency "google-style", "~> 0.3"
  gem.add_development_dependency "minitest", "~> 5.10"
  gem.add_development_dependency "minitest-autotest", "~> 1.0"
  gem.add_development_dependency "minitest-focus", "~> 1.1"
  gem.add_development_dependency "minitest-rg", "~> 5.2"
  gem.add_development_dependency "rake", ">= 10.0"
  gem.add_development_dependency "simplecov", "~> 0.9"
end
