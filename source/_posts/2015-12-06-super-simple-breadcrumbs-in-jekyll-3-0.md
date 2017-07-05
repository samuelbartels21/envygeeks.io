---
url-id: f594d1fe
id: 2c79dad6-0abf-42f7-96dd-c7960472b288
title: Breadcrumbs in Jekyll 3.0+
tags: [jekyll, ruby]
---

More tips for Jekyll 3.0: Breadcrumbs.  Over the years I've seen some overly complicated breadcrumb plugins for Jekyll, lots which do complicated Ruby for a trivial topic.  For Jekyll 3.0 lets show you how to do super simple breadcrumbs.

<p class="code-file">
  _plugins/breadcrumbs.rb
</p>

```ruby
Jekyll::Hooks.register :pages, :pre_render do |page, payload|
  drop = Drops::BreadcrumbItem

  if page.url == "/"
    out = drop.new(page, payload)
    payload["breadcrumbs"] = [
      out
    ]

  else
    payload["breadcrumbs"] = []
    pth = page.url.split("/")

    0.upto(pth.size - 1) do |int|
      joined_path = pth[0..int].join("/")
      item = page.site.pages.find do |page_|
        joined_path == "" && page_.url == "/" || \
          page_.url == joined_path
      end

      if item
        out = drop.new(item, payload)
        payload["breadcrumbs"] << out
      end
    end
  end
end
```

<p class="code-file">
  _plugins/drops/breadcrumb_item.rb
</p>

```ruby
module Drops
  class BreadcrumbItem < Liquid::Drop
    extend Forwardable

    def_delegator :@page, :data
    def_delegator :@page, :url

    # --
    # Initialize a new instance.
    # --
    def initialize(page, payload)
      @payload = payload
      @page = page
    end

    # --
    # The title of the post or page.
    # @return [String]
    # --
    def title
      @page.data["title"]
    end
  end
end
```

And in your default layout:

{% raw %}
```html
<div class"breadcrumbs">
  {% for crumb in breadcrumbs %}
    <a href="{{ crumb.url | prepend:site.baseurl }}">
      {{ crumb.title }}
    </a>

    {% unless forloop.last == true %}
      <span class="breadcrumb-splitter">
        &gt;
      </span>
    {% endunless %}
  {% endfor %}
</div>
```
{% endraw %}
