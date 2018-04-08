# Frozen-string-literal: true
# Copyright: 2017 Jordon Bedwell - MIT License
# Encoding: utf-8

require "active_support"
require "liquid/drop/hash_or_array"
require "active_support/core_ext"
require_relative "metadata/cache"
require_relative "metadata/errors"
require_relative "metadata/version"
require_relative "metadata/query"

module Jekyll
  module Metadata
    Drop = Liquid::Drop::HashOrArray
    module_function

    # --
    # Run multiple hooks.
    # @return [nil]
    # --
    def setup
      site
      docs
    end

    # --
    # Setup hooks on docs, posts, pages.
    # @return [nil]
    # --
    def docs
      Jekyll.logger.debug("metadata") { "registering posts, pages, documents hooks" }
      Jekyll::Hooks.register [:posts, :pages, :documents], :pre_render do |d, p|
        p["page"]["metadata"] = Drop.new(Queries::Stat.run({
          path: path_of(d),
        }).as_json)
      end
    end

    # --
    # Setup hooks on site.
    # @return [nil]
    # --
    def site
      Jekyll.logger.debug("metadata") { "registering site hook" }
      Jekyll::Hooks.register :site, :pre_render do |_, p|
        p["site"]["metadata"] = Drop.new(Queries::Site.run.as_json)
        p["github"] = {
          "langs" => Drop.new(Queries::Github::Langs.run.as_json),
          "repos" => Drop.new(Queries::Github::Repos.run.as_json),
        }
      end
    end

    # --
    def path_of(doc)
      return doc.realpath if doc.respond_to?(:realpath)
      Pathutil.new(doc.site.in_source_dir(doc.relative_path))
        .relative_path_from(Pathutil.pwd).to_s
    end
  end
end

# --
# Setup
# --
Jekyll::Metadata.setup
