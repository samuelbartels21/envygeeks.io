# Frozen-String-Literal: true
# Copyright 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require "active_support"
require "pathutil"

module EnvyGeeks
  class << self
    attr_accessor :config
  end

  # --
  # Reads the Jekyll configuration, this is necessary
  #   because some of our stuff loads well before Jekyll
  #   to setup, so we need to see the config before
  #   Jekyll even sees it's own config.
  # @return [Hash] the config.
  # --
  def self.config
    @config ||= begin
      file = Pathutil.pwd.join("_config.yml")
      data = file.read_yaml({
        safe: true
      })
    end
  end

  # --
  # Whether or not we are inside of development
  #   environment, this is where most people work
  #   but you should set it yourself.
  # @return [true,false] truth.
  # --
  def self.dev?
    @dev ||= begin
      %w(dev development).freeze.include?(Jekyll.env)
    end
  end

  # --
  # Whether or not we are inside of production
  #   this is what you should set yourself to if
  #   you are building a deployment.
  # @return [true,false] truth.
  # --
  def self.production?
    @production ||= begin
      %w(prod production).freeze.include?(Jekyll.env)
    end
  end

  # --
  # A quick Pathutil (joinable) into the source dir, this
  #   hopefully follows the spec of Jekyll by allowing you to
  #   set the source dir (with `source`) and then if it's
  #   not set, defaulting to the current path.
  # @return [Pathutil] the path.
  # --
  def self.source_dir
    @source_dir ||= begin
      backup = Pathutil.pwd.join(".").expand_path
      Pathutil.new(config.fetch("source", backup)). \
        expand_path
    end
  end

  # --
  # A quick `Pathutil` (joinable) into the plugins dir,
  #   this is by default like Jekyll, in that it will first
  #   check and see where you have set it to and if it's
  #   not set, default to the current path.
  # @return [Pathutil] the path.
  # --
  def self.plugins_dir
    @plugins_dir ||= begin
      backup = source_dir.join("_plugins")
      Pathutil.new(config.fetch("plugins_dir", backup)). \
        expand_path.join("envygeeks")
    end
  end

  # --
  # A quick Pathutil (joinable) into the cache dir, and as
  #   agreed to in https://goo.gl/TdzJWV we will default to
  #   `.jekyll-cache` unless you define `cache_dir` key.
  # @return [Pathutil] the path.
  # --
  def self.cache_dir
    @cache_dir ||= begin
      backup = source_dir.join(".jekyll-cache")
      Pathutil.new(config.fetch("cache_dir", backup)). \
        expand_path.join("envygeeks")
    end
  end
end

# --
# Register a hook that allows us to set the
# configuration in a way that I wish to access it
# AKA with symbolized keys.
# --
Jekyll::Hooks.register :site, :after_init do |v|
  EnvyGeeks.config = v.config.symbolize_keys
end
