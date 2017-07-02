---
url-id: f4e98882
id: 942ac263-0685-4c15-a894-db8affb0b59f
title: On Shell Escaping in Ruby.
tags:
  - ruby
---

Its standard is too low, you can't accidentally double escape.  Here let me fix that:

```ruby
module Utils
  def escape(str)
    str.gsub!(/(\\?[^A-Za-z0-9_\-.,:\/@\n])/) do
      $1.start_with?("\\") ? $1 : "\\#{$1}"
    end

    str.gsub!(/\n/,
      "'\n'"
    )

    str
  end
end
```

```ruby
Utils.escape(Utils.escape(
  "hello\\ world"
))

# => "hello\\ world"
```
