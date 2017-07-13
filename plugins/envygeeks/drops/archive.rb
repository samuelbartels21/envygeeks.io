# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require_relative "tags"
require_relative "../filters"

module EnvyGeeks
  module Drops
    class Archive < Liquid::Drop
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
      def initialize(site:)
        @site = site
        @site.config["archive"] ||= {}
        @site.config["archive"]["weights"] ||= {}
        @site.config["archive"]["weights"]["int"] ||= 2.0
        @site.config["archive"]["weights"]["max"] ||= 3.0
      end

      # --
      # Get all of the site tags.
      # --
      def tags
        return @tags if @tags
        @tags = @site.tags.keys.map do |tag|
          Drops::Tag.new(tag, {
            :site => @site,
          })
        end
      end

      # --
      # Tags with weights
      # --
      def weighted_tags
        return @weighted_tags ||= begin
          div = @site.config["archive"]["weights"]["int"].to_f / tags.size.to_f
          max = @site.config["archive"]["weights"]["max"].to_f

          _t  = @site.posts.docs.each_with_object({}) do |post, hash|
            post.data["tags"].each do |tag|
              hash[tag.to_s] ||= []
              hash[tag.to_s].push(post)
            end
          end

          out = _t.sort_by { |_, v| v.size }.map { |v| v.first }
          out = out.to_enum.with_index(1.0).map do |k, i|
            weight = (div * i + 1).round(1)
            weight = max if weight > max

            Drops::Tag.new(k, {
              :weight => weight, :site => @site,
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
        waterfall(@site.posts.docs.group_by { |v| v.date.year }). \
          values.inject(&:|)
      end
    end
  end
end

# --
# Hook:Site:PreRender
# Jekyll:Register
# --
Jekyll::Hooks.register :site, :pre_render do |site, payload|
  payload["envygeeks"] ||= {}
  payload["envygeeks"]["archive"] = EnvyGeeks::Drops::Archive.new({
    :site => site
  })
end
