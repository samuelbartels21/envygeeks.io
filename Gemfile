source "https://rubygems.org"
gem "jekyll"
gem "uglifier"
gem "nokogiri"
gem "gemoji"
gem "pry"

# --
# Testing
# --
group :test do
  gem "html-proofer"
  gem "luna-rspec-formatters"
  gem "rspec"
end

# --
# Plugins
# --
group :jekyll_plugins do
  gem "font-awesome-sass"
  gem "autoprefixer-rails"
  gem "jekyll-assets"

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
  end
end
