# Github GraphQL Metadata

Jekyll Github GraphQL Metadata is like Github-Metadata by Jekyll, except it pulls all your metadata from the GraphQL API, supports inline authors, has defaults, and is much faster on queries.  It also implements a cache so that your builds aren't slowed down until you start up your server again, when everything can be refreshed.

## Usage

```ruby
group :jekyll_plugins do
  base_url = "https://github.com/envygeeks/envygeeks.io/gems"
  gem "jekyll-github-graphql-meta", {
    git: "#{base_url}/gems/jekyll-github-graphql-meta"
  }
end
```
