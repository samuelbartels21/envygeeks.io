# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require_relative "page"
require "jekyll/generator"
require_relative "config"
require "octokit"

module Jekyll
  module Github
    module Docs
      class Generator < Jekyll::Generator
        attr_reader :config

        # --
        def initialize(config)
          @config = config
        end

        # --
        def generate(site)
          GraphQL::Meta.new(site).repos.each do |v|
            next unless allowed?(v[:name])

            data = get(v)
            skwd = { site: site }
            mock = mock_dir(**skwd).join(v[:name]).sub_ext(".md")
            doc = Page.new(mock, collection: collection_on(**skwd), site: site)
            doc.content = "{% raw %}#{decode(data.content)}{% endraw %}"
            collection_on(**skwd).docs << doc
          end
        end

        # --
        def get(v)
          self.class.cache.fetch(v[:name]) do
            Jekyll.logger.debug("GithubDocs") { "fetching #{v[:name]}" }
            Octokit.readme(v[:rel], {
              accept: accept,
            })
          end
        end

        # --
        def decode(v)
          encoding = Encoding::UTF_8
          Base64.decode64(v)
            .force_encoding(encoding)
        end

        # --
        def mock_dir(site:)
          @dir ||= begin
            Pathutil.new(site.source).join("_docs")
          end
        end

        # --
        def accept
          "application/json"
        end

        # --
        def allowed?(v)
          return true if allowed.any? { |r| v =~ r }
          disallowed.none? do |r|
            v =~ r
          end
        end

        # --
        def allowed
          @allowed ||= begin
            Array(config["docs"]["allowed"]).map do |v|
              to_regexp(v)
            end
          end
        end

        # --
        def disallowed
          @disallowed ||= begin
            out = [%r!^.*$!] if allowed.none? || allowed == "*"
            out ||= Array(config["docs"]["disallowed"]).map do |v|
              to_regexp(v)
            end

            out
          end
        end

        # --
        def to_regexp(v)
          v.strip!

          v = ".*" if v == "*"
          unless anchor?(v)
            v = "^#{v}$"
          end

          Regexp.new(v)
        end

        # --
        def anchor?(v)
          v.start_with?("^", "\\A", "\\a") || v.end_with?("$", "\\Z", "\\z")
        end

        # --
        def collection_on(site:)
          site.collections["docs"] ||= Then begin
            Jekyll::Collection.new(site, "docs")
          end
        end

        # --
        # --
        def self.cache
          Jekyll.cache_dir.mkdir_p
          @cache ||= Jekyll::Cache::FileStore
            .new("docs")
        end
      end
    end
  end
end
