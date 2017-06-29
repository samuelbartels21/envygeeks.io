# Frozen-String-Literal: true
# Copyright 2016 Jordon Bedwell - MIT License
# Encoding: UTF-8

require_relative "../tag/helpers"

module Drops
  class Tag < Liquid::Drop
    include ::Tag::Helpers
    extend Forwardable::Extended
    attr_reader :weight

    def initialize(site:, tag:, weight: 0.0)
      @tag = tag.to_s
      @weight = weight.to_f
      @site = site
    end

    def url
      File.join(
        *tag_path
      )
    end

    rb_delegate :to_s, :to => :@tag
    rb_delegate :inspect, :to => :@tag
    rb_delegate :==, :to => :@tag
  end
end

# --
# Roll over each post and turn it's tags into an array of
# TagDrop's so that you can get the URL, name and other stuff
# without having to do it all again, manually.
# --

Jekyll::Hooks.register :site, :pre_render do |site, payload|
  site.posts.docs.each do |post|
    post.data["tag_drops"] = post.data["tags"].map do |tag|
      Drops::Tag.new({
        :tag => tag, :site => site
      })
    end
  end
end
