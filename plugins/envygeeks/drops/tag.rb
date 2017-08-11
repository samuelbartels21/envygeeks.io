# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require_relative "../liquid/drop/str"
require_relative "../helpers/tag"

module EnvyGeeks
  module Drops
    class Tag < Liquid::Drop::Str
      attr_reader :weight, :site
      extend Forwardable::Extended
      rb_delegate :name, to: :@tag, alias_of: :to_s
      include Helpers::Tag

      # --
      def initialize(tag, site:, weight: 1)
        super(tag)

        @site = site
        @weight = weight
        @tag = tag
      end

      # --
      def url
        File.join(*tag_path)
      end

      # --
      # @return [[]] the tags.
      # Loop through tags, set them up and then, pass
      #   them back out.
      # --
      def self.to_tags(site:)
        div = 4.0 / site.tags.values.max_by(&:size).size
        site.tags.each_with_object([]) do |(k, v), o|
          weight = format("%.2f", div * v.size)

          o << new(k, {
            weight: weight.to_f,
            site: site,
          })
        end
      end
    end
  end
end

# --
# Roll over each post and turn it's tags into an array of
# TagDrop's so that you can get the URL, name and other stuff
# without having to do it all again, manually.
# --

Jekyll::Hooks.register :site, :pre_render, priority: 99 do |s, p|
  tags = EnvyGeeks::Drops::Tag.to_tags(site: s)

  s.posts.docs.each do |d|
    d.data["tags"] = d.data["tags"].map do |t|
      o = tags.find do |v|
        v == t
      end

      o
    end
  end
end
