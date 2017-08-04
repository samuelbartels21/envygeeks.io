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
      include Helpers::Tag

      # --
      def initialize(tag, site:, weight: 0)
        super(tag)
        @weight, @site = weight, \
          site
      end

      def url
        File.join(*tag_path)
      end
    end
  end
end

# --
# Roll over each post and turn it's tags into an array of
# TagDrop's so that you can get the URL, name and other stuff
# without having to do it all again, manually.
# --

Jekyll::Hooks.register :site, :pre_render, priority: 99 do |s, _|
  s.posts.docs.each do |d|
    d.data["tags"] = d.data["tags"].map do |t|
      EnvyGeeks::Drops::Tag.new(t, {
        site: s
      })
    end
  end
end
