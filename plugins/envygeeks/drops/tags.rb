# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require_relative "../helpers/tag"

module EnvyGeeks
  module Drops
    class Tag < Liquid::Drop
      extend Forwardable::Extended
      rb_delegate :to_s, :to => :@tag
      rb_delegate :inspect, :to => :@tag
      rb_delegate :==, :to => :@tag
      attr_reader :weight, :site
      include Helpers::Tag

      def initialize(tag, site:, weight: 0)
        @tag = tag.to_s
        @weight = weight
        @site = site
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

Jekyll::Hooks.register :site, :pre_render do |site, payload|
  site.posts.docs.each do |post|
    post.data["tags"] = post.data["tags"].map do |tag|
      EnvyGeeks::Drops::Tag.new(tag, {
        :site => site
      })
    end
  end
end
