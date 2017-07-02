require_relative "../filters"

module Tag
  class Url < Liquid::Tag
    TAG = %q{<a href="%s">%s</a>}
    include Filters

    # --
    # @param tag Internal
    # @param id The id passed via `{% url id %}`
    # @param tokens Internal
    # --
    def initialize(tag, id, tokens)
      @id = id
      super
    end

    # --
    # Search for a `post`, `page`, or `document` that has a matching
    # `url-id` in it's frontmatter. Returning the resulting url as a full
    # anchor tag that gets output.
    #
    # @param context The Liquid context.
    # @return [string] An anchor tag.
    # --
    def render(context)
      @context = context
      site = context.registers[:site]
      docs = site.pages | site.posts.docs
      docs = docs.find_all { |v| v.data["url-id"] == @id.strip }
      raise "Logical Error: Duplicate `url-id` found..." if docs.size > 1
      raise "Unable to find document" if docs.size == 0

      url = canonical_url(docs.first)
      format(TAG, url, docs.first.data["title"])
    end
  end
end

Liquid::Template.register_tag("url", Tag::Url)
