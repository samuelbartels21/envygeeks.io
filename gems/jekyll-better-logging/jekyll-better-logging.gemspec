# Frozen-string-literal: true
# Copyright: 2017 - MIT License
# Encoding: utf-8

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "jekyll/better_logging/version"

Gem::Specification.new do |s|
  s.require_paths = ["lib"]
  s.authors = ["Jordon Bedwell"]
  s.version = Jekyll::BetterLogging::VERSION
  s.homepage = "http://github.com/envygeeks/jekyll-better-logger"
  s.files = %w(Rakefile Gemfile README.md LICENSE) + Dir["lib/**/*"]
  s.summary = "A better logger for Jekyll."
  s.email = ["jordon@envygeeks.io"]
  s.name = "jekyll-better-logging"
  s.license = "MIT"

  s.required_ruby_version = ">= 2.3.0"
  s.add_runtime_dependency "jekyll", "~> 3.6"
end
