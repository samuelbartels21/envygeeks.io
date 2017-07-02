---
url-id: 089be010
id: 84377fd7-5293-4fc4-b7ba-ba26faf9c591
title: Mocking ActiveRecord to test concerns.
tags:
  - rspec
  - rails3
  - active-record
  - rails4
  - ruby
---

Part three of my series on Rails 4 (previously: {% url 8d91b663 %} and {% url 7340aa65 %}) is about mocking `ActiveRecord` to test conerns and other modules in a more independent way. _**I was doing this long before Rails 4 was out but now that Rails 4 is promoting skinny models and controllers it might be good for me to explain how I test "concerns".**_

## The back story on why.

When I first started working with Rails I had always thought that a lot of Rails people put too much into one spot, and not enough was extractable as independent modules that had dependencies on certain things (like `ActiveRecord` or a certain column and such.) I knew I wasn't original in my idea that things should be decoupled, but it seemed to me that it wasn't such a big idea within the Rails community at the time.

In Rails 4 we finally saw people talking about it, split shit up and turn a lot of it into concerns, make your code more independent (though I don't remember if that was part of the full message over just making skinny models.) Still though, we never saw a way to mock `ActiveRecord` (that I was able to find.) So I ended up having to extract my oldest mocks over to Rails 4 so I that I could test the new (in path) concerns.

## Creating the helpers to Mock

When I designed the helpers to mock `ActiveRecord` I knew that I wouldn't want it to be done in each and every `it` or `specify`. I actually wanted it to be done early and to remain constant until the end of all the tests for that spec. So that meant several things. (1): I needed to `extend` instead of `include`, (2): I needed to use `after(:all)` instead of `after(:each)`. (3): I didn't want to have to use metadata to have it extended and (4): It should clean up after itself. So I ended up with:

```ruby
module RSpec
  module Helpers
    module ActiveRecordMocks

      # --
      # @param [String,Symbol] name the name of the model
      # Mock a model and create a table.
      # --
      def mock_active_record_model(name, &block)
        create_temp_table(
          name, &block
        )

        klass = Class.new(ActiveRecord::Base)
        Object.const_set("#{name}_table".camelize, klass).class_eval do
          self.table_name = "__#{name}_table"
        end
      end

      # --
      # Create a temporary table.
      # --
      def create_temp_table(table, &block)
        ActiveRecord::Migration.suppress_messages do
          ActiveRecord::Migration.create_table "__#{table}_table",
              :temporary => true do |t|

            block.call(t)
          end
        end

        after :all do
          ActiveRecord::Migration.suppress_messages do
            ActiveRecord::Migration.drop_table "__#{table}_table"
          end
        end
      end
    end
  end
end
```

The idea behind it was that if I wanted or needed a temporary table it would probably be for all of the specs in that `describe` block. So I would only need to do:

```ruby
describe MyConcern do
  mock_active_record_model(:table_name) do |t|
    t.text(
      :my_row
    )
  end

  it 'should have an available ActiveRecord' do
    expect { TableNameTable.new }.to_not(
      raise_error
    )
  end
end
```

It also needed to try to attempt to prevent clashes inside of the database, so I also prefix everything with `__` and suffix it with `_table`, this way we try not to clash with anything... but surely it wouldn't be hard to make it completely random since I always return both the Model and Table Name.  

You can see it in this interaction:

```sh
[1] pry(#<Class>)> mock_active_record_model(:my_active_record_concern) do |t|
[1] pry(#<Class>)*   t.string(
[1] pry(#<Class>)*     :hello
[1] pry(#<Class>)*   )
[1] pry(#<Class>)* end

# => [
#  MyActiveRecordConcernTable(),
#  "__my_active_record_concern_table"
# ]
```

***Note: Don't pay attention if it says the table does not exist because it's temporary.***

## Tying it into RSpec.

Since I didn't want to have to use meta-data to have it extend the base class it was going into I also needed to just straight up `config.extend` instead of `config.extend :condition => true` (note the `:condition => true` it's the default in RSpec 3)

```ruby
RSpec.configure do |config|
  config.extend RSpec::Helpers::ActiveRecordMocks
end
```
