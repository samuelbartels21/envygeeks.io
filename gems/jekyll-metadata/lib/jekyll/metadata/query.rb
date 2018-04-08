# Frozen-string-literal: true
# Copyright: 2017 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

require "graphql/client/http"
require "liquid/drop/hash_or_array"
require "active_support/inflector"
require "graphql/client"

module Jekyll
  module Metadata
    class Query
      module ClassMethods

        # --
        # Whether you're class is cacheable.
        # @note this is useful for things like limits
        # @return [true, false]
        # --
        def cacheable?
          true
        end

        # --
        # Returns the cache key
        # @note the class name as a path.
        # @return [String]
        # --
        def cache_key
          u, r = github.values_at(:user, :repo)
          name = self.name.gsub("::", ":").downcase
          @cache_key ||= "#{name}:#{u}/#{r}"
        end

        # --
        # @note this is things like expires_in
        # @return [Hash<Symbol,<String,Integer>>]
        # Returns the cache opts
        # --
        def cache_opts
          @cache_opts ||= {
            expires_in: cacheable? ? 1.hour : 0.minutes,
          }
        end

        # --
        # Tells us this is not loopable
        # @note add #loopable_run if you want this to be true
        # @see .run if you want to know more
        # @return [true, false]
        # --
        def loopable?
          @loopable ||= respond_to?(:loopable_run, true)
        end

        # --
        # Provide vars for querying
        # rubocop:disable Metrics/LineLength
        # @param after [String] the end cursor
        # @param count [Integer] the results to pull with each query
        # @param repo  [String] the repository
        # @param user  [String] the user
        # @return Hash
        # --
        def vars(after: nil, user: github[:user], repo: github[:repo], branch: github[:branch], count: 96)
          after = nil if after == true

          {
            after: after,
            branch: branch,
            count: count,
            user:  user,
            repo:  repo,
          }
        end

        # --
        # rubocop:enable Metrics/LineLength
        # @param after [String] the end cursor
        # @return [GraphQL::Client::Result] if loopable?
        # @return [Hash, Array] if !loopable?
        # Run the query.
        # --
        def run(**kwd)
          Cache.fetch cache_key, cache_opts do
            loopable? ? loopable_run(**kwd) : format(query(**kwd))
          end
        end

        # --
        def query(**kwd)
          vars = vars(**kwd)
          Jekyll.logger.debug "metadata: ", "querying for: #{self.name}"
          Jekyll.logger.debug "metadata: ", "querying var: #{vars.inspect}"
          out = CLIENT.query(self::QUERY, variables: vars)
          raise Errors::GraphQL, out if out.errors.any?

          out
        end

        # --
        def github
          out = {
            user: ENV["GITHUB_USER"],
            branch: ENV["GITHUB_BRANCH"],
            repo: ENV["GITHUB_REPO"],
          }

          return out if out[:user] && out[:branch] && out[:repo]
          url = %x(git remote get-url #{Shellwords.shellescape(`git remote`.strip)}).strip
          out[:branch] ||= `git branch`.strip.gsub(%r!^\*\s*!, "")

          if url && url =~ %r!git@github\.com:(.*)\/(.*)\.git!
            out[:user] ||= Regexp.last_match[1]
            out[:repo] ||= Regexp.last_match[2]
          end

          out
        end

        # --
        # Merges two result sets
        # @note Merges arrays, and hashes
        # @note This is for results
        # @return [Class]
        # --
        def merge_results(a, b)
          hash = merge(a.to_h, b.to_h)
          data = self::QUERY.schema_class.new(hash["data"])
          GraphQL::Client::Response.new(hash, {
            data: data,
          })
        end

        # --
        # Merge two hashes, or arrays
        # @note typically you'll use this from #merge_results
        # @return [Hash, Array]
        # --
        def merge(a, b)
          if !array_or_hash?(a, b)
            raise ArgumentError, "bad value a, or b"
          else
            return a | b if a.is_a?(Array)
            a.merge b do |_, o, n|
              if array_or_hash?(o, n)
                merge(o, n)
              else
                n
              end
            end
          end
        end

        # --
        # Tells you if a, b are a hash, or array
        # @note this is used inside of #merge mostly
        # @return [true, false]
        # --
        def array_or_hash?(a, b)
          (a.is_a?(Hash) && b.is_a?(Hash)) || (a.is_a?(Array) && b.is_a?(Array))
        end
      end

      # --
      # @note this is automatic
      # Allows us to ship the ClassMethods
      # @return [nil]
      # --
      def self.inherited(klass)
        klass.send(:extend, ClassMethods)
      end

      # --
      # @return [Proc] the headers to set.
      # Returns a proc that holds headers method for GraphQL
      # @note It seems that Github/GraphQL doesn't have auth.
      # rubocop:disable Lint/NestedMethodDefinition
      # --
      def self.headers
        proc do
          def headers(*)
            token = ENV["GITHUB_TOKEN"] || raise(Errors::NoToken)

            {
              "For"           => "https://envygeeks.io",
              "License"       => "MIT License - © 2017 - 2018 Jordon Bedwell",
              "Library"       => "EnvyGeeks Github GraphQL Query Machine",
              "Authorization" => "bearer #{token}",
              "Auth"          => "bearer #{token}",
            }
          end
        end
      end

      # --
      API_URL = "https://api.github.com/graphql"
      ENDPOINT = GraphQL::Client::HTTP.new(API_URL, &headers)
      JSON = Jekyll.cache_dir.tap(&:mkdir_p).join("github.json")
      SCHEMA = GraphQL::Client.load_schema(JSON.to_s) if JSON.file?
      SCHEMA = GraphQL::Client.dump_schema(ENDPOINT, JSON.to_s) unless JSON.file?
      CLIENT = GraphQL::Client.new(execute: ENDPOINT, schema: SCHEMA)
      DIR = Pathutil.new(__dir__).join("graphql")
    end
  end
end

# --
# Queries
# --
require_relative "queries/stat"
require_relative "queries/site"
require_relative "queries/github/repos"
require_relative "queries/github/langs"
require_relative "queries/limit"
