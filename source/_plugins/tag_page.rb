# Frozen-String-Literal: true
# Copyright 2016 Jordon Bedwell - MIT License
# Encoding: UTF-8

require_relative "tag_helpers"

class TagPage < Jekyll::Page
  include TagHelpers

  # --

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
  # Pull out the base data from within the layout.
  # Most of the time this will simply just be empty.
  # @return [Hash]
  # --
  private
  def process_tag_template
    read_yaml(@base, tag_layout)
    process(
      @name
    )
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
