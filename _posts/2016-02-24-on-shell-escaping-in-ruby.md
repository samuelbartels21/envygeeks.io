---
title: On Shell Escaping in Ruby
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
