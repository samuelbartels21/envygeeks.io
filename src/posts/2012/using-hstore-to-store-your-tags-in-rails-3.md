---
author: envygeeks
title: Using PostgreSQL HStore to store your tags in Rails 3
slug: using-hstore-to-store-your-tags-in-rails
date: 2012-11-17T00:00:00-06:00
tags: [
  hstore,
  postgresql,
  rails3,
  rails,
  ruby
]
---

Given the hundreds of ways to store tags in a `database`, one of the original
and oldest is to create a one-to-many relation with a possible join with
`ActiveRecord` and another is a way that I haven't ever seen before that I _like
to think_ I came up with, it uses `hstore` to reduce the need for an extra query
in some cases.

## Why?

By using `hstore` you require less queries, 2 less than `ActiveRecord::Model`'s
and you still in theory have the same amount of duplication with less required
space (because now you have 2 less tables and less rows.) I have not tested the
theory on space, but the queries is what intrigues me the most about using
`hstore` for tags. Now instead of needing relations you should create a
serializer and a method on the singleton.

## The code.

```ruby
class Post < ActiveRecord::Base
  serialize :tags, Tags

  class Tags
    class << self

      # --
      # Load the serialized data.
      # @return [Array]
      # --
      def load(data)
        return [] if data.blank?
        data = data.split(%r!"([^"]+)"[^"]+!).reject { |v| v.blank? }
        data.map do |v|
          v =~ /^\d+$/ ? v.to_i : v
        end
      end

      # --
      # Dup the serialized data.
      # @return [true,false]
      # --
      def dump(data)
        return false unless data.is_a?(Array)
        data.inject([]) { |a, t| a << "\"#{t.to_slug}\" => NULL" } \
          .join(",\s")
      end
    end
  end

  class << self

    # --
    # Find by the tags you decide.
    # @return [ActiveRecord]
    # --
    def find_by_tags(*tags)
      limit(1).find_all_by_tags(*tags).first
    end

    # --
    # Return all the recrods that have the tag.
    # @return [ActiveRecord]
    # --
    def find_all_by_tags(*tags)
      raise ArgumentError, "tag required" if tags.count < 1
      where(tags.inject("") do |s, t|
        s += " AND tags ? #{connection.quote(
          t
        )}"
      end)
    end
  end
end

# --
# Post.new(tags: [:test1, :test2])
# Post.find_by_tag(:test1).tags => [
#   :test1
# ]
# --
```
