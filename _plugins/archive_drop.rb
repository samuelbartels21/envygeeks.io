# Frozen-String-Literal: true
# Copyright 2016 Jordon Bedwell - MIT License
# Encoding: UTF-8

require_relative "tag_drop"
require_relative "filters"

class ArchiveDrop < Liquid::Drop
  include Filters

  # --
  # Do not allow these methods to be called from within the Drop.
  # Even though it's only used by people who know what they are doing,
  # we still need to prevent our own mistakes...
  # --
  Filters.instance_methods.each do |method|
    private method
  end

  # --
  # Initialize a new instance.
  # --
  def initialize(site)
    @site = site
    @site.config["archive"] \
      ||= {}
  end

  # --
  # Get all of the site tags.
  # --
  def tags
    return @tags ||= begin
      @site.tags.keys.map do |tag|
        TagDrop.new({
          :site => @site, :tag => tag
        })
      end
    end
  end

  # --
  # Tags with weights
  # --
  def weighted_tags
    return @weighted_tags ||= begin
      div = @site.config["archive"].fetch("weights", {}).fetch("int", 2.0).to_f / tags.size.to_f
      max = @site.config["archive"].fetch("weights", {}).fetch("max", 3.0).to_f
      _t  = @site.posts.docs.each_with_object({}) do |post, hash|
        post.data["tags"].each do |tag|
          (hash[tag.to_s] ||= []).push(
            post
          )
        end
      end

      out = _t.sort_by { |_, v| v.size }.map { |v| v.first }
        .to_enum.with_index(1.0).map do |key, index|
          weight = div * index + 1
          weight = weight.round(
            1
          )

          if weight > max
            then weight = max
          end

          TagDrop.new({
            :site => @site,
            :weight => weight,
            :tag => key
          })
        end

      # Tries to mitigate an ugly output of the tags.
      @site.config["archive"].fetch("shuffle", 3).times do
        out = out.shuffle
      end
      out
    end
  end

  # --
  # Pull out a waterfall list of posts.
  # --
  def posts
    waterfall(@site.posts.docs,
      true
    )
  end
end

# --

Jekyll::Hooks.register :site, :pre_render do |site, payload|
  payload["archive"] = ArchiveDrop.new(
    site
  )
end
