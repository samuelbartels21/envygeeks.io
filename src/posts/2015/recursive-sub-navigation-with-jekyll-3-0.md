---
author: envygeeks
title: Recursive (sub-)navigation with Jekyll 3.0
date: 2015-12-06T00:00:00-06:00
tags: [
  jekyll,
  ruby
]
---

Jekyll 3 is stable, and a lot of the sites I help manage that use Jekyll have
all updated and a lot of them had some hefty customization's but with Jekyll 3.0
customization is easier.  Here is how you can go about making recursive
navigation with Jekyll 3.0 with minimal code:

<p class="code-file">
  _plugins/nav.rb
</p>

```ruby
Jekyll::Hooks.register :site, :pre_render do |site, payload|
  payload["nav"] = []

  site.pages.each do |val|
    if val.url.gsub(/\A\//, "").split("/").size.between?(0, 1)
      payload["nav"] << Drops::NavItem.new(
        val, payload
      )
    end
  end
end
```

<p class="code-file">
  _plugins/drops/nav_item.rb
</p>

```ruby
module Drops
  class NavItem < Liquid::Drop
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
    # The page title.
    # --
    def title
      @page.data.title
    end

    # --
    # The Sub-Pages.
    # --
    def pages
      return @payload["nav"] if url == "/"
      comp_ary = split(url)

      @page.site.pages.each_with_object([]) do |page, out|
        if page.url != "/" && (url_ary = split(page.url)) != comp_ary && \
            url_ary[0..-2] == comp_ary

          out << self.class.new(page, @payload)
        end
      end
    end

    # --
    # Whether or not we have sub-pages.
    # --
    def sub_pages?
      size > 0
    end

    # --
    # The size of the pages.
    # --
    def size
      pages.size
    end

    # --
    # Split the URL.
    # --
    private
    def split(url)
      url = url.gsub(/\A\//, "")
      url = url.chomp(File.extname(url))
      url.split("/")
    end
  end
end
```

<p class="code-file">
  _includes/nav.html
</p>

```html
<ul>
  {% for _page in looping %}
    {% capture url %}{{ _page.url | prepend:site.baseurl }}{% endcapture %}
    {% assign title = _page.data.title %}

    <li>
      <a href="{{ url }}">{{ title }}</a>
      {% if _page.sub_pages? %}
        {% assign looping = _page.pages %}
        {% include nav.html %}
      {% endif %}
    </li>
  {% endfor %}
</ul>
```

Now in your main layout do this:

```html
{% looping = site.nav %}
{% include   nav.html %}
```
