# Frozen-string-literal: true
# Copyright: 2017 Jordon Bedwell - MIT License
# Encoding: utf-8

require "graphql/client"
require "liquid/drop/hash_or_array"
require "active_support/inflector"
require "graphql/client/http"
require "jekyll/cache"

require_relative "metadata/result"
require_relative "metadata/formatters"
require_relative "metadata/helpers"
require_relative "metadata/errors"
require_relative "metadata/drop"

module Jekyll
  class Metadata
    attr_reader :cache, :logger, :site

    API_URL = "https://api.github.com/graphql"
    RAW_QUERIES = Pathutil.new(__dir__).join("metadata.graphql").read
    TOKEN = ENV["GITHUB_TOKEN"] || raise("No `GITHUB_TOKEN' on `ENV'")
    JSON = Jekyll.cache_dir.tap(&:mkdir_p).join("github.json")

    http   = GraphQL::Client::HTTP.new(API_URL, &Helpers.headers)
    schema = GraphQL::Client.load_schema(JSON.to_s) if JSON.file?
    schema = GraphQL::Client.dump_schema(http, JSON.to_s) unless JSON.file?
    Client = GraphQL::Client.new({ execute: http, schema: schema })
      .tap { |o| Queries = o.parse(RAW_QUERIES) }

    # --
    # Get repos from Github GraphQL
    # @param site [Jekyll::Site] the Jekyll site.
    # @return self
    # --
    def initialize(site)
      @site = site
    end

    # --
    # @param file [String] the file.
    # Allows you to stat a file, getting some basic
    #   informations on it, such as when it was created,
    #   who created it, and so-forth.
    # @return [{}] the result.
    # --
    def stat(file)
      self.class.cache.fetch(File.join("file", file)) do
        out = results({
          path: file,
          graphql: {
            limit: Float::INFINITY,
            path: %i(repository ref target history),
            query: Queries::Stat,
          },
        })

        # --
        # This query is expensive because of the way that
        #   Github currently handles `CommitHistoryConnection`. We
        #   have to extract the entire history to get the
        #   original creator of a file...
        # @see https://goo.gl/xaVFka
        # --

        out = out&.sort_by(&:committed_date)&.[](0)
        out ? Formatters.commit(out) : Formatter.default(site)
      end
    end

    # --
    # @return [Array<{}>] array of normalized hashes.
    # Returns the results, cleaned up as a proper array
    #   of hashes that you can use.  This is a low-level wrapper
    #   around the many types of repo queries we have.
    # --
    def repos(**kwd)
      self.class.cache.fetch :repos do
        graphql = { query: Queries::Repos, path: %i(user repositories) }
        results graphql: graphql, **kwd do |v|
          year = DateTime.parse(v.pushed_at).year
          if Time.now.year == year && v.primary_language
            Formatters.repo(v)
          end
        end
      end
    end

    # --
    # @return [{}] the repository information.
    # Gets information about your current repository for you.
    #   Returns the last commit, and otherwise basic information
    #   that would be useful for your footers.
    # --
    def repo(**kwd)
      self.class.cache.fetch :repo do
        graphql = { query: Queries::Repo, path: %i(repository) }
        result(graphql: graphql, **kwd) do |v|
          Formatters.repo(v.results).merge({
            commits: Helpers.loop(v.results.ref.target.history) do |c|
              Formatters.commit(c)
            end,
          })
        end
      end
    end

    # --
    # Wraps around and loops results with your block.
    # @return [Array<Hash>] an array of hashes that you normalize.
    # @note You can use edges/node | nodes, dealers choice.
    # --
    private
    def results(graphql:, **kwd, &block)
      after, out = nil, []

      while out.count < graphql.fetch(:limit, limit)
        query = query(**kwd.merge(after: after, graphql: graphql))
        Helpers.loop(query.results, into: out, &block)
        break unless query.page_info.has_next_page
        after = query.page_info.end_cursor
      end

      out
    end

    # --
    # Gets a single result from the database.
    # @note If you have a edge or set of nodes, use `results`
    # @todo Make sure you `validate!` on this method!
    # @return [{}] the value gowtten back.
    # --
    private
    def result(**kwd)
      out = query(**kwd)
      if block_given?
        out = yield out
      end

      out
    end

    # --
    # @see https://goo.gl/5KS36r
    # Returns the results of our query.
    # @note this passes the raw data (#to_h) to avoid a few bugs in
    #   graphql-client. There are bugs dealing when dealing with fragments,
    #   especially nested fragments like ours.
    # @return [{}] the result
    # --
    private
    def query(graphql:, after: nil, **kwd)
      out = Client.query(graphql[:query], {
        variables: build({
          after: after, **kwd
        }),
      })

      raise Errors::GraphQLError, out unless out.errors.none?
      nodes(out.to_h.deep_symbolize_keys, {
        graphql: graphql,
      })
    end

    # --
    # @return [Hash] the vars to be shipped
    # Builds out the variable hash that will be shipped
    #   to GraphQL.
    # --
    def build(after: nil, **kwd)
      out = kwd.merge({
        repo:  Helpers.info[:repo],
        user:  Helpers.info[:user],
        count: limit,
        after: after,
      })

      out
    end

    # --
    # @return [@todo] the nodes at the path.
    # Gets the data at the path point the user designates
    #   and passes to us.
    # --
    private
    def nodes(result, graphql:)
      return nil unless result

      out = Result.new({
        results: {},
        pageInfo: {
          startCursor: nil,
          hasPreviousPage: false,
          hasNextPage: false,
          endCursor: nil,
        },
      })

      path = [:data] | Array(graphql[:path])
      path.map do |v|
        result = result[v]
      end

      out[:results] = result
      page_info = Hash(result.delete(:pageInfo))
      out[:pageInfo] = page_info
      out
    end

    # --
    # Gives us the total results to expect.
    # @note Github allows a limit of up to 100.
    # @return Integer
    # --
    private
    def limit
      @site.config.fetch(:graphql_limit, 12)
    end

    # --
    public
    def self.cache
      Jekyll.cache_dir.mkdir_p
      @cache ||= Jekyll::Cache::FileStore
        .new("github")
    end

    # --
    def self.site(s, p)
      git = new(s)
      p.merge!({
        "git"   => Drop.new(git.repo),
        "repos" => Drop.new(git.repos.map do |v|
          Drop.new(v)
        end),
      })
    end

    # --
    def self.page(o, p)
      path = Pathutil.new(o.site.source).relative_path_from(Pathutil.pwd)
      path = path.join(o.respond_to?(:realpath) ?
        o.realpath : o.relative_path)

      git = new(o.site)
      if path.file?
        stat = git.stat(path)
        p["meta"] = {
          "github" => Drop.new(stat),
        }
      end
    end

    # --
    def self.setup
      Jekyll::Hooks.register(:site, :pre_render, &method(:site))
      Jekyll::Hooks.register(%i(pages documents),
        :pre_render, &method(:page))
    end
  end
end


Jekyll::Metadata.setup
