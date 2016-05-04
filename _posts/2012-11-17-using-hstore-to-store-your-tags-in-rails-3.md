---
title: Using HStore to store your tags in Rails 3
---

There are many ways to store tags in a `database`, one of the original and oldest is to just create a one to many relation with a possible join with `ActiveRecord` and another is a way that I haven't ever seen before that I _like to think_ I came up with that uses HStore to reduce the need for an extra query in some cases.

## Why?

By using HStore you require (maybe) less queries, 2 less `ActiveRecord::Model`'s and you still in theory have the same amount of duplication with less required space (because now you have 2 less tables and several less rows.)

I have clearly not tested the theory on space, but the queries is what intrigues me the most about using `hstore` for tags. Now instead of needing relations you need only create a serializer and a method on the singleton.

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
        data.split(%r!"([^"]+)"[^"]+!).reject { |val| value.blank? }
          .map do |val|
            value =~ /^\d+$/ ? value.to_i : value
          end
      end

      # --
      # Dup the serialized data.
      # @return [true,false]
      # --
      def dump(data)
        return false unless data.is_a?(Array)
        data.inject([]) do |a, t|
          a << "\"#{t.to_slug}\" => NULL"
        end

        .join(
          ",\s"
        )
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
      where(tags.inject("") do |str, tag|
        str+= " AND tags ? #{connection.quote(
          tag
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

## Will it work?

Sure, I use it in production everyday on new client sites to save the need to add a dependency on `acts-as-taggable-on` because it's just too complicated when I have such a simple solution like this. The only downside is now you can't easily port your codebase from one database to the other, because as of right now only `PostgreSQL` supports hashes (as far as I know.)
