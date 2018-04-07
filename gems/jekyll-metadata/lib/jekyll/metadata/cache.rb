# Frozen-string-literal: true
# Copyright: 2017 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

require "jekyll/cache"

module Jekyll
  module Metadata
    class Cache < Jekyll::Cache::FileStore
      def initialize
        Jekyll.cache_dir.mkdir_p
        super "github"
      end

      # --
      # Creates a new cache instance.
      # @return [Cache]
      # --
      def self.cache
        @cache ||= new
      end

      # --
      # Wraps around %method%
      # @return [Object]
      # @!method get
      # @!method fetch
      # @!method delete
      # @!method set
      # --
      %i(read fetch write delete).each do |v|
        define_singleton_method v do |*a, &b|
          cache.public_send(v, *a, &b)
        end
      end
    end
  end
end
