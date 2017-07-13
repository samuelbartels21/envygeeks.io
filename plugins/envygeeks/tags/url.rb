# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require_relative "../helpers/tag"
require_relative "../helpers/site"
require_relative "../filters"

module EnvyGeeks
  module Tags
    class URL < Liquid::Tag
      include Helpers::Tag
      TAG = %q{<a href="%s">%s</a>}
      include Helpers::Site
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
      # @todo Move @context, site to site, context through tag helpers.
      # @return [string] An anchor tag.
      # --
      def render(context)
        @context = context
        docs = site.pages | site.posts.docs
        docs = docs.find_all { |v| v.data["url-id"] == @id.strip }
        raise "Logical Error: Duplicate `url-id` found..." if docs.size > 1
        raise "Unable to find document" if docs.size == 0

        url = canonical_url(docs.first)
        format(TAG, url, docs.first.data["title"])
      end
    end
  end
end

Liquid::Template.register_tag("url", EnvyGeeks::Tags::URL)
