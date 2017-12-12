# Frozen-string-literal: true
# Copyright: 2016 - 2017 - MIT License
# Encoding: utf-8

source "https://rubygems.org"
gem "jekyll", "~> 3.6", require: false
gem "uglifier", "~> 4.0", require: false
gem "sprockets", "~> 4.0.beta", require: false
gem "font-awesome-sass", "~> 4.7", require: false
gem "liquid-hash-or-array-drop", "~> 1.0", require: false
gem "autoprefixer-rails", "~> 7.1", require: false
gem "graphql-client", "~> 0.12", require: false
gem "nokogiri", "~> 1.8", require: false
gem "babel-transpiler", require: false
gem "octokit", require: false
gem "sassc", require: false
gem "bootstrap", require: false

unless File.file?("/.dockerenv")
  gem "mini_racer", {
    require: false,
  }
end

# --
# Testing
# --
group :test do
  gem "rspec", "~> 3.6", require: false
  gem "luna-rspec-formatters", "~> 3.7", require: false
  gem "html-proofer", "~> 3.7", require: false
  gem "rubocop", require: false
end

# --
# Plugins
# --
group :jekyll_plugins do
  gem "jekyll-commonmark"
  gem "jekyll-sanity", "~> 1.0"
  gem "jekyll-posts_by_year", "~> 1.0"
  gem "jekyll-post-tags", "~> 1.0"
  gem "jekyll-cache", "~> 1.0"

  # --
  # Locally I prefer to work my version since I tend to do
  #   manual QA and debugging with my own site which is the
  #   defacto example of Jekyll-Assets at it's basic.
  # --
  gem "jekyll-better-logging", path: "gems/jekyll-better-logging"
  gem "jekyll-assets", ENV["CI"] != "true" ?
    { path: "~/development/src/github.com/envygeeks/jekyll-assets" } :
    { git:  "https://github.com/envygeeks/jekyll-assets" }

  # --
  # Non-CI Plugins
  # --
  unless ENV["CI"] == "true"
    group :development do
      gem "jekyll-reload", {
        path: "~/development/src/github.com/anomaly/jekyll-reload",
      }
    end
  end
end

# --
# Non-CI Development
# --
unless ENV["CI"] == "true"
  group :development do
    gem "travis", require: false
    gem "pry", require: false
  end
end
