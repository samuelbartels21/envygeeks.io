# Frozen-string-literal: true
# Copyright: 2016 - 2017 - MIT License
# Encoding: utf-8

source "https://rubygems.org"
gem "jekyll", "~> 3.5"
gem "uglifier", "~> 3.2"
gem "font-awesome-sass", "~> 4.7"
gem "liquid-hash-or-array-drop", "~> 1.0"
gem "autoprefixer-rails", "~> 7.1"
gem "graphql-client", "~> 0.12"
gem "nokogiri", "~> 1.8"
gem "gemoji", "~> 3.0"

unless File.exist?("/.dockerenv")
  gem "mini_racer"
end

# --
# Testing
# --
group :test do
  gem "rspec", "~> 3.6", require: false
  gem "html-proofer", "~> 3.7", require: false
  gem "luna-rspec-formatters", "~> 3.7", require: false
  gem "rubocop", require: false
end

# --
# Plugins
# --
group :jekyll_plugins do
  gem "jekyll-sanity", "~> 1.0"
  gem "jekyll-posts_by_year", "~> 1.0"
  gem "jekyll-post-tags", "~> 1.0"
  gem "jekyll-cache", "~> 1.0"
  gem "jekyll-assets", "~> 3.0.alpha", {
    git: "https://github.com/jekyll/jekyll-assets",
  }

  # --
  # Non-CI Plugins
  # --
  unless ENV["CI"] == "true"
    group :development do
      gem "jekyll-livereload"
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
