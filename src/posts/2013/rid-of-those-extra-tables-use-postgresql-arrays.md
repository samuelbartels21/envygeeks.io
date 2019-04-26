---
author: envygeeks
title: Rid of those extra tables, use PostgreSQL arrays.
date: Wed, 12 Jun 2013 00:00:00 -0500
tags: [
  rails4,
  postgresql,
  rails,
  ruby
]
---

Rails 4 will hit final release soon and over the last couple of months I've had
the "pleasure" of playing with it in both production testing, and in standard
testing, and over that time I've accumulated a list of features I most look
forward to. I can say that I'm a little bit excited for once about a Rails
release, because of some of the features I've been using since long before Rails
thought about it.

One of my absolute favorites coming into Rails 4 is the addition of "native"
support for PostgreSQL arrays. To some people this can have an impact on how
they build their code and can even simplify the management of not-only that code
but the tables they use. We no longer need multiple tables for tagging (not that
we did before since Arrays have been in existence since I can remember.)

What I mean is, now that Rails has "native" support for PostgreSQL arrays,
people will start to use them more, and instead of seeing "skills" and "tags" in
different tables we will see them on the user themselves and now instead of
using flexibility as an excuse for MongoDB we will now see people use `hstore`
instead, unless MongoDB is something they actually want to use (I'm judging you.
>:))

## The Migration.

```ruby
class CreatePosts < ActiveRecord::Migration
  def up
    enable_extension :hstore
    create_table :posts do |t|
      t.text :title, :null => false
      t.integer :author, :null => false
      t.string :tags, :null => false, :array => true
      t.hstore :ops, :null => false
      t.text :slug, :null => false
      t.timestamps

      t.index :author, {
        :unique => false
      }
    end

    execute "CREATE INDEX idx_tags_on_posts ON posts USING GIN(tags)"
    execute "CREATE INDEX idx_opts_on_posts ON posts USING GIN(opts)"
  end
end
```

The migration above is as easy as the Model below. The one thing to note here
though is that unlike `hstore`, for a PostgreSQL `array` you create your type
and then tell PostgreSQL it's an array. Which means you can do it for most any
type, for example: `t.integer :author, :null => :false, :array => true`.

## The Model.

```ruby
class Posts < ActiveRecord::Base
  class << self

    # --
    # @return [ActiveRecord]
    # @param [String] tag The tag.
    # Pull posts by tag.
    # --
    def with_tag(tag)
      where("? = ANY (tags)", tag)
    end
  end
end
```

Like before we get "native" support for array and `hstore` you must build your
own helper methods. I for one do not disagree with this approach but others
might like it, so I've build a basic `with_tag` helper. If you would like to
know more ways you can query PostgreSQL please check out the [documentation][1]

## The Data.

```ruby
Posts.new({
  :title   => "Test",
  :slug    => "test",
  :author  => 1,

  :opts => {
    :publish => true
  },

  :tags => [
    :test
  ]
)
```

```ruby
Posts.by_tag(:test)
# => #<ActiveRecord::Relation [
# =>   #<Posts id: 1, ..., tags: ["test"], ...>
# => ]>
```

## And a List of Other Features I Like:

*   Russian Doll caching. Caches in my caches.
*   StrongParams. MassAssignment moved to the controller now.
*   Sprockets moved to sprockets-rails, yay for updates?

[1]: https://www.postgresql.org/docs/9.2/static/arrays.html
