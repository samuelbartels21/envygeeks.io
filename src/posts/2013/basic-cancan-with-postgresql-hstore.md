---
author: envygeeks
title: Basic CanCan in Rails 4 using PostgreSQL `hstore`
slug: basic-cancan-with-postgresql-hstore
date: 2013-06-13T00:00:00-05:00
tags: [
  hstore,
  postgresql,
  rails3,
  rails4,
  rails,
  ruby
]
---

With Rails 4 coming soon so I thought I would write about my new favorite
features, and post some tutorials on what I am doing with Rails 4. The second in
this series is doing a basic CanCan style permissions handler with PostgreSQL's
`hstore`.

<!-- MORE -->

Before Rails 4 I would always opt to use CanCan because I did not want to have
to build my own serializer or to use the `hstore` gem which had a some minor
bugs in some data I would store, but when Rails 4 first did it's RC I decided
it's time I move to my own "home grown" solution. Here is how I went about it in
a basic manner!

## The Challenge

The challenge here is not if they have permissions to do this on a specific
page, not if the role allows it, it's whether the user has the permission to
complete the task. Tying it into a role and doing a fall back for special
circumstances is not that hard to dream up, and to add so we'll save that for
later, since this purpose serves well. That is if you were to ask me, you might
not be so decide for yourself.

## Building The `Users` Model

The `Users` model was easy enough to start, we know we wanted to use Omniauth
and GitHub authentication because we have GitHub accounts, that was the quickest
solution, unless we used Devise but still: Omniauth. We design our `Users`
migration and model around that, but you can design your migration and model any
way you want, take notes of the important parts!

```ruby
class CreateUsers < ActiveRecord::Migration

  # --
  # Create the tables.
  # --
  def up
    enable_extension :hstore
    create_table :users do |t|
      t.text :name, :null => false
      t.text :username, :null => false
      t.text :github_token, :null => false
      t.hstore :permissions, :null => false
      t.hstore :options, :null => false
      t.text :email, :null => false

      t.timestamps
      t.index :email, {
        :unique => true
      }
    end

    %W(options permissions).each do |f|
      execute "CREATE INDEX #{f}_index_on_users ON users USING GIN(#{f})"
    end
  end

  # --
  # Drop the tables.
  # --
  def down
    drop_table :users
    disable_extension :hstore
  end
end
```

```ruby
class Users < ActiveRecord::Base
  # Empty
end
```

Now it's as easy as doing:

```sh
rake db:create db:migrate
```

```ruby
Users.new(
  :github_token => '',
  :name => 'Users Name',
  :email => 'user@name.com',
  :username => 'user',
  :options => {}

  :permissions => {
    :create_post => true
  },
).save!
```

And now we can do:

```ruby
Users.first.permissions["create_post"]
#=> "true"
```

But *wait*, what is going on here? Why is `true` coming out as "true"? Does
Rails convert strings to primitives inside of `hstore`? I guess since they think
it might be too intrusive we should do that ourselves.

## "Primitives"

The first thing I needed to decide was whether I wanted to convert the possibles
over to primitives... or... should I stick with the values. The basic example is
do I want: "t(rue)?", "1" and "y(es)?" to be `true` or do I want "true" to be
`true`? In the end for me the decision was that I want "true" to be `true`, it's
easier.

I also needed to decide if I wanted to be explicit or implicit. Meaning do I
want to automatically convert all hstore fields and have to decide which hstore
columns would not get converted or should I decide which ones do get converted?
This was an easy one for me, most of the time I will be storing true, false and
1/0 values so I decided I would be explicit on exclude. And after all that
deciding I ended up with:

```ruby
module ModelConcerns
  module HstorePrimitivesConcern
    extend ActiveSupport::Concern

    included do
      %W(after_find after_initialize before_validation).each do |m|
        send(m, :__convert_hstore_to_primitives)
      end
    end

    # --
    # Convert primitives.
    # --
    private
    def __convert_hstore_to_primitives
      self.class.__hstore_columns.each do |f|
        unless new_record? || !self[f] ||
              self.class.__hstore_primitive_skips.include?(f)

          __convert_to_primitives(f)
        end
      end
    end

    # --
    # Convert primitives.
    # --
    private
    def __convert_to_primitives(field)
      self[field] = self[field].inject({}) do |h, (k, v)|
        v = __convert_value_to_primitive(v)
        h.update({
          k => v
        })
      end
    end

    # --
    # Convert primitives
    # --
    private
    def __convert_value_to_primitive(value)
      case value
        when 'true' then true
        when 'false' then false
        when '' then nil
        when /\A\d{1,}\Z/ then value.to_i
      else
        value
      end
    end

    module ClassMethods

      # --
      # Primites to skip.
      # --
      def __hstore_primitive_skips()
        return @__hstore_primitive_skips ||= [
          #
        ]
      end

      # --
      # The HStore columns.
      # --
      def __hstore_columns
        return @__hstore_columns ||= columns.keep_if { |c| \
          c.type == :hstore }.map(&:name)
      end

      # --
      # Primitives to skip.
      # --
      def skip_hstore_primitive_conversion(field)
        field = field.to_s

        if columns_hash[field] && columns_hash[field].type == :hstore
          __hstore_primitive_skips.push(field)
        end
      end
    end
  end
end
```

```ruby
require 'rspec/helper'
describe ModelConcerns::HstorePrimitivesConcern do
  mock_active_record_model :hstore_primitives_concern do |t|
    t.hstore :hstore1
    t.hstore :hstore2
  end

  #

  before :all do
    class HstorePrimitivesConcernTable
      include ModelConcerns::HstorePrimitivesConcern
      skip_hstore_primitive_conversion :hstore2
    end
  end

  #

  let(:data) do
    {
      'test1' => true,
      'test3' => false,
      'test2' => 2
    }
  end

  #

  it 'converts to primitives properly' do
    HstorePrimitivesConcernTable.new({
      :hstore1 => data
    }).save!

    data.each do |k, v|
      result = HstorePrimitivesConcernTable.first.hstore1[k]
      expect(result).to(eq(v))
    end
  end

  #

  it "doesn't convert fields it's told to skip" do
    HstorePrimitivesConcernTable.new({
      :hstore2 => data
    }).save!

    data.each do |k, v|
      result = HstorePrimitivesConcernTable.first.hstore2[k]
      expect(result).to(eq(v.to_s))
    end
  end
end
```

Now that I had that solved, I had to decide whether I wanted my permissions
concern to handle the inclusion of `HstorePrimitivesConcern` because it's the
one who relied on it, or if I wanted to make it explicit. In the end I decided
that I would have the permissions concern handle it, so I moved onto building my
permissions concern.

## Adding `can?`

Out of it all, this would be the easiest thing to do because all I had to do was
add a can method, include `HstorePrimitivesConcern` and copy my fancy temporary
table code over to a new spec and run it. It couldn't be too hard, but then
again, we could say that about most, that end up being hard. I ended up with:

```ruby
module ModelConcerns
  module PermissionsConcern
    extend ActiveSupport::Concern

    included do
      include ModelConcerns::HstorePrimitivesConcern
    end

    # --
    # Whether a user can do something.
    # --
    def can?(permission)
      permissions ? !!self['permissions'][permission] : false
    end
  end
end
```

```ruby
require 'rspec/helper'

describe ModelConcerns::PermissionsConcern do
  mock_active_record_model :permissions_concern do |t|
    t.hstore(:permissions)
  end

  #

  before :all do
    class PermissionsConcernTable
      include ModelConcerns::PermissionsConcern
    end
  end

  #

  let(:data) do
    {
      'update_posts' => false,
      'update_permissions' => true
    }
  end

  #

  it 'forwards can? over to permissions' do
    PermissionsConcernTable.new({
      :permissions => data
    }).save!

    data.each do |k, v|
      result = PermissionsConcernTable.first.can?(k)
      expect(result).to(eq(v))
    end
  end
end
```

## Bringing it all together.

After all that work, all I had was tests, and independent `Concerns` and nothing
to show on the `Users` model. Now it's time to include it, and see how well it
works.

```ruby
class Users < ActiveRecord::Base
  include ModelConcerns::PermissionsConcern
end
```

and now _things came together_. Look!

```ruby
Users.first.can?(:create_posts)
#=> true
```
