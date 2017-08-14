source "https://rubygems.org"
gem "jekyll", "~> 3.5"
gem "uglifier", "~> 3.2"
gem "font-awesome-sass", "~> 4.7"
gem "liquid-hash-or-array-drop", "~> 1.0"
gem "autoprefixer-rails", "~> 7.1"
gem "graphql-client", "~> 0.12"
gem "nokogiri", "~> 1.8"
gem "gemoji", "~> 3.0"

# --
# Testing
# --
group :test do
  gem "html-proofer", "~> 3.7"
  gem "luna-rspec-formatters", "~> 3.7"
  gem "rspec", "~> 3.6"
end

# --
# Plugins
# --
group :jekyll_plugins do
  gem "jekyll-sanity", "~> 1.0"
  gem "jekyll-posts_by_year", "~> 1.0"
  gem "jekyll-post-tags", "~> 1.0"
  gem "jekyll-assets", "~> 2.3"
  gem "jekyll-cache", "~> 1.0"

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
    gem "travis"
    gem "pry"
  end
end
