# Jekyll Synced Logging

Jekyll Better logging solves a fundamental problem with Jekyll's logger.  It doesn't use a Mutex, and it's not thread safe.  This logger solves that problem by switching Jekyll's own logger to use the Logger built into stdlib, which does have a Mutex, and is thread safe, so your logs never come out without a new line, and never come out, out of order.  In the future I might also allow custom formatting of the logs, including JSON output so that they can be consumed.

## Usage

```ruby
group :jekyll_plugins do
  gem "jekyll-synced-logging", {
    git: "https://github.com/envygeeks/envygeeks.io/jekyll-synced-logger"
  }
end
```
