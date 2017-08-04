# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require_relative "../helpers/tag"

module EnvyGeeks
  module Pages
    class Tag < Jekyll::Page
      include Helpers::Tag
      attr_accessor :site, :base, :tag, \
        :dir, :name

      # --
      # Initialize a new instance.
      # @return [Self]
      # --
      def initialize(site, tag)
        @site = site
        @tag = tag
        @base = site.source
        @dir, @name = tag_path
        process_tag_template
        setup_defaults
      end

      # --
      # Since this class is dynamic, and it's path being
      #   dynamic too, we provide a "realpath" method so that
      #   anything using Git, or otherwise can determine
      #   what the actual path is.
      # @return string
      # --
      def realpath
        @site.tags[@tag].sort_by { |v| v.data["date"] \
          }.first.relative_path
      rescue => e
        require"pry"
        Pry.output = STDOUT
        binding.pry
      end

      # --
      # Pull out the base data from within the layout.
      # Most of the time this will simply just be empty.
      # @return [Hash]
      # --
      private
      def process_tag_template
        read_yaml(@base, tag_layout)
        process(@name)
      end

      # --
      # Set the defaults.
      # --
      private
      def setup_defaults
        @data["type"] = "tag"
        @data["description"] ||= "Tag: #{@tag}"
        @data["title"] ||= "Tag: #{@tag}"
        @data["tag"] = @tag
      end
    end
  end
end
