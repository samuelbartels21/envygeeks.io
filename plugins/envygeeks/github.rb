# Frozen-String-Literal: true
# Copyright 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require "graphql/client"
require "graphql/client/http"
require_relative "github/result"
require "active_support/inflector"
require_relative "github/formatters"
require_relative "github/helpers"
require_relative "github/errors"
require "active_support/cache"
require_relative "cache"

module EnvyGeeks
  class Github

    # --
    # @note can be slow on first usage.
    # @return [GraphQL::Schema] the schema.
    # Returns the schema, or dumps the schema from http
    #   and saves it, then returns it to you for your own
    #   private usage.
    # --
    def self.schema
      path = GQLDir.join("github.json").to_s
      return GraphQL::Client.load_schema(path) if File.file?(path)
      GraphQL::Client.dump_schema(RmtUrl, path)
    end

    # --
    # Setup everything as a constant, this way it can all
    # be reused... We can add and remove queries by adding in
    # a parse method and then going and adding the query into
    # the `github.graphql` file with minimal work.
    # --

    RmtUrl = "https://api.github.com/graphql"
    GQLDir = Jekyll.plugins_dir.join("envygeeks", "graphql")
    Remote = GraphQL::Client::HTTP.new(RmtUrl, &Helpers.headers)
    Client = GraphQL::Client.new(execute: Remote, schema: schema)
    Query  = Client.parse(GQLDir.join("github.graphql").read)
    Cache  = EnvyGeeks::Cache.new("github")
    Token  = ENV["GITHUB_TOKEN"]

    # --
    # Get repos from Github GraphQL
    # @param site [Jekyll::Site] the Jekyll site.
    # @return self
    # --
    def initialize(site)
      @site  = site
    end

    # --
    # @param file [String] the file.
    # Allows you to stat a file, getting some basic
    #   informations on it, such as when it was created,
    #   who created it, and so-forth.
    # @return [{}] the result.
    # --
    def stat(file)
      Cache.fetch(File.join("file", file)) do
        out = results({
          path: file,
          graphql: {
            limit: Float::INFINITY, query: Query::Stat,
            path: [:repository,
              :ref, :target, :history
            ].freeze
          }
        })

        # --
        # This query is expensive because of the way that
        #   Github currently handles `CommitHistoryConnection`. We
        #   have to extract the entire history to get the
        #   original creator of a file...
        # @see https://goo.gl/xaVFka
        # --

        Formatters.commit(out.sort_by(&:committed_date).fetch(0))
      end
    end

    # --
    # @return [Array<{}>] array of normalized hashes.
    # Returns the results, cleaned up as a proper array
    #   of hashes that you can use.  This is a low-level wrapper
    #   around the many types of repo queries we have.
    # --
    def repos(**kwd)
      Cache.fetch(:repos) do
        path = [:user, :repositories].freeze
        results(graphql: { query: Query::Repos, path: path }, **kwd) do |v|
          if v.primary_language && Time.now.year == \
          DateTime.parse(v.pushed_at).year
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
      Cache.fetch(:repo) do
        path = [:repository]
        result(graphql: { query: Query::Repo, path: path }, **kwd) do |v|
          Formatters.repo(v.results).merge({
            commits: Helpers.loop(v.results.ref.target.history) do |c|
              Formatters.commit(c)
            end
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
        Helpers.loop(query.results, { into: out }, &block)
        break unless query.page_info.has_next_page
        after = query.page_info.
          end_cursor
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
    def query(graphql: , after: nil, **kwd)
      out = Client.query(graphql[:query], variables: kwd.merge({
        repo:  Helpers.info[:repo],
        user:  Helpers.info[:user],
        count: limit,
        after: after,
      }))

      raise Errors::GraphQLError, out if out.errors.size != 0
      nodes(out.to_h.deep_symbolize_keys, {
        graphql: graphql
      })
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
        :results => nil,
        :pageInfo => {
          :startCursor => nil,
          :hasPreviousPage => false,
          :hasNextPage => false,
          :endCursor => nil
        }
      })

      path = [:data] | graphql.fetch(:path)
      path.each { |v| result = result&.[](v) }
      out.merge!({ results:  result,
        pageInfo: result.delete(:pageInfo) \
          || out[:pageInfo] })

      out.freeze
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
  end
end

# --
Jekyll::Hooks.register :site, :pre_render do |s, p|
  git = EnvyGeeks::Github.new(s)
  p.merge!({
    "git"   => EnvyGeeks::Drops::HashOrArray.new(git.repo),
    "repos" => EnvyGeeks::Drops::HashOrArray.new(
      git.repos
    )
  })
end

# --
Jekyll::Hooks.register [:pages, :documents, :posts], :pre_render do |d, p|
  src  = Pathutil.new(d.site.source)
  src  = src.relative_path_from(Pathutil.pwd)
  path = src.join(d.realpath) if d.respond_to?(:realpath)
  path = src.join(d.relative_path) unless path
  git  = EnvyGeeks::Github.new(d.site)

  if path.file?
    stat = git.stat(path)
    p.merge!({
      "page" => {
        "stat" => EnvyGeeks::Drops::HashOrArray.new(stat)
      }
    })
  end
end
