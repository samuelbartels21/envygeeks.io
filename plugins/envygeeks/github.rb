# Frozen-String-Literal: true
# Copyright 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require "graphql/client"
require "graphql/client/http"
require "active_support/inflector"
require "active_support/cache"
require_relative "cache"

module EnvyGeeks
  class Github
    Infinity = Float::INFINITY

    # --
    # @return [Proc] the headers to set.
    # Returns a proc so that the `EndPoint` can set it's headers.
    # @note It seems that Github/GraphQL doesn't support
    #   auth so we need to add it manually at
    #   that point.
    # --
    def self.headers
      Proc.new do
        def headers(ctx)
          {
            "Authorization" => "bearer #{Token}"
          }
        end
      end
    end

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
    GQLDir = EnvyGeeks.plugins_dir.join("graphql")
    Remote = GraphQL::Client::HTTP.new(RmtUrl, &headers)
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
      @limit = EnvyGeeks.config.fetch(
        :graphql_query_limit, 12
      )
    end

    # --
    # Infers the current repository name from the origin.
    #   And if there is no name then it just dumps and fails
    #   because you shouldn't be using this without git.
    # @return [String] the name
    # --
    def info
      @info ||= begin
        remotes = `git remote -v`
        remotes = remotes.gsub(/\((fetch|push)\)$/m, "").split(/\s*$\n+/).
          uniq.keep_if { |v| v.match(/github\.com/) }

        remote = remotes[0] if remotes.size == 1
        remote = remotes.find { |v| v.start_with?("origin\t") }
        remote = remote.gsub(/\.git$\n*/, "").split(":")
        remote = remote.fetch(-1).split("/")

        {
          user: remote.fetch(0),
          repo: remote.fetch(1),
        }
      end
    end

    # --
    # Defaults the GraphAPI max limit.
    # --
    def graphql_limit
      if @limit == Infinity
        return 100
      end

      Integer(@limit)
    end

    # --
    # Gives us the total results to expect.
    # @note Github allows a limit of up to 100.
    # @return Integer
    # --
    def limit(n = @limit)
      o = @limit
      @limit = n
      yield
    ensure
      @limit = o
    end

    # --
    # @return [ActiveSupport::Duration] the time.
    # Tells you how long until we plan to expire something
    #   In production this is always set to 0 minutes, in dev
    #   it's set to around 6 minutes, this way your sites
    #   don't build slow when you are working.
    # --
    def expires
      @expires ||= begin
        (Jekyll.env == "development" ? 6 : 0).minutes
      end
    end

    def file_info(file)
      Cache.fetch(File.join("file", file), :expires_in => expires,
      :ttl_racetime => 1.minute) do
        path = "repository/ref/target/history"
        results = [
          #
        ]

        limit Infinity do
          results = results({
            graphql_path: path,
            graphql_query: Query::FileCommitInfo,
            path: file,
          })
        end

        # --
        # This query is expensive because of the way that
        #   Github currently handles `HistoryConnection`. We
        #   have to extract the entire history to get the
        #   original creator of a file...
        # @see https://goo.gl/xaVFka
        # --

        result = results.fetch(-1)

        # --

        {
          created_at: DateTime.parse(result.committed_date),

        }
      end
    end

    # --
    # @return [Array<{}>] array of normalized hashes.
    # Returns the results, cleaned up as a proper array
    #   of hashes that you can use.  This is a low-level wrapper
    #   around the many types of repo queries we have.
    # --
    def repos(**kwd)
      Cache.fetch("repos", :expires_in => expires) do
        path = "user/repositories"

        results(graphql_query: Query::Repos, graphql_path: path, **kwd) do |v|
          unless v.primary_language?
            next
          end

          pushed_at = DateTime.parse(v.pushed_at)
          if Time.now.year == pushed_at.year
            {
              url: v.url,
              owner: v.owner.login,
              path: v.name_with_owner,
              forks: v.forks.total_count,
              language: v.primary_language&.name&.downcase,
              pull_requests: v.pull_requests.total_count,
              stargazers: v.stargazers.total_count,
              issues: v.issues.total_count,
              pushed_at: pushed_at,
              name: v.name
            }
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
      Cache.fetch("repo", :expires_in => expires) do
        path = "repository"

        result(graphql_query: Query::Repo, graphql_path: path, **kwd) do |v|
          {
            name: v.name,
            owner_url: v.owner.url,
            issues_enabled: v.has_issues_enabled?,
            name_with_owner: v.name_with_owner,
            owner: v.owner.login,
            url: v.url,

            commits: loop_on(v, graphql_path: "ref/target/history") do |v|
              {
                url: v.commit_url,
                short_oid: v.abbreviated_oid,
                message: v.message_headline,
                oid: v.oid
              }
            end
          }
        end
      end
    end

    # --
    # @return @todo
    # Returns the results of our query.
    # @private
    # --
    private
    def query(graphql_query:, after: nil, **kwd)
      Client.query(graphql_query, variables: kwd.merge({
        count: graphql_limit,
         repo: info[:repo],
         user: info[:user],
        after: after,
      }))
    end

    # --
    # Gets the result and loop it back to you.
    # @note this is split out so that it can be used with
    #   or without results, that way you can loop subresults
    #   if you really wish to loop them.
    # @return Class<Results>
    # --
    private
    def loop_on(results, into: [], **kwd)
      nodes(results, **kwd).each do |v|
        v = v.respond_to?(:node) ? v.node : v

        if block_given?
          result = yield v

          if result
            into << result
          end
        else
          into << v
        end

        if into.count == @limit
          break
        end
      end

      into
    end


    # --
    # Wraps around and loops results with your block.
    # @note you can use edges/node | nodes, dealers choice.
    # @return [Array<Hash>] an array of hashes that
    #   you normalize.
    # --
    private
    def results(graphql_query:, graphql_path:, **kwd, &block)
      after, out = nil, []

      while out.count < @limit
        results = query(graphql_query: graphql_query, after: after, **kwd)
        loop_on(results, into: out, graphql_path: graphql_path, &block)
        info = at_path(results, graphql_path: graphql_path).page_info
        break unless info.has_next_page? && \
          after = info.end_cursor
      end

      out
    end

    # --
    # Gets a single result from the database.
    # @note If you have a edge or set of nodes, use `results`
    # @return [{}] the value gotten back.
    # --
    def result(graphql_query:, graphql_path:, **kwd)
      out = query(graphql_query: graphql_query)
      out = nodes(out, graphql_path: graphql_path)
      return yield out if block_given?

      out
    end

    # --
    # @return [Array<Object>] the count and nodes.
    # Get the nodes, along with all the nodes that are currently
    #   within the data set (result.)
    # --
    private
    def nodes(result, graphql_path:)
      out = at_path(result, graphql_path: graphql_path)
      return out.edges if out.respond_to?(:edges)
      return out.nodes if out.respond_to?(:nodes)
      out
    end

    # --
    # @return [@todo] the nodes at the path.
    # Gets the data at the path point the user designates
    #   and passes to us.
    # --
    private
    def at_path(result, graphql_path:)
      return nil unless result

      out = result.respond_to?(:data) ? result.data : result
      graphql_path.split("/").each do |v|
        out = out&.send(v)
      end

      out
    end
  end
end

# --
# Hook:Site:PreRender
# Jekyll:Register
# --
Jekyll::Hooks.register :site, :pre_render do |s, p|
  drp = EnvyGeeks::Drops::HashOrArray
  git = EnvyGeeks::Github.new(s)
  p[  "git"] = drp.new(git.repo)
  p["repos"] = drp.new(
    git.repos
  )
end
