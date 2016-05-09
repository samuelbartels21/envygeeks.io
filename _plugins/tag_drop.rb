# Frozen-String-Literal: true
# Copyright 2016 Jordon Bedwell - MIT License
# Encoding: UTF-8

require_relative "tag_helpers"

class TagDrop < Liquid::Drop
  extend Forwardable::Extended
  include TagHelpers

  def initialize(site:, tag:)
    @tag = tag.to_s
    @site = site
  end

  # --

  def url
    File.join(
      *tag_path
    )
  end

  # --

  rb_delegate :to_s, :to => :@tag
  rb_delegate :inspect, :to => :@tag
  rb_delegate :==, :to => :@tag
end

# --
# Roll over each post and turn it's tags into an array of
# TagDrop's so that you can get the URL, name and other stuff
# without having to do it all again, manually.
# --

Jekyll::Hooks.register :site, :pre_render do |site, payload|
  site.posts.docs.each do |post|
    post.data["tag_drops"] = post.data["tags"].map do |tag|
      TagDrop.new({
        :tag => tag, :site => site
      })
    end
  end
end
