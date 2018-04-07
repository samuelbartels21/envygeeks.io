# Frozen-string-literal: true
# Copyright: 2017 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Metadata
    module Queries
      module Github
        class Repos < Query
          QUERY = CLIENT.parse(DIR.join("github/repos.graphql").read)::Repos

          # --
          # Format the results from #run
          # @param result [GraphQL::Client::Result] the results
          # @param owner [Private<Private>] private
          # @return [Hash]
          # --
          def self.format(result)
            {
              name: result.name,
              forks: result.forks.total_count,
              pushed_at: Time.parse(result.pushed_at),
              pull_requests: result.pull_requests.total_count,
              stargazers: result.stargazers.total_count,
              language: result&.primary_language&.name,
              owner: Stat.format_author(result.owner),
              issues: result.issues.total_count,
              rel: result.name_with_owner,
              url: result.url,
            }
          end

          # --
          # Loops over results to get all the results.
          # @return [Hash] see #format
          # --
          def self.loopable_run(**kwd)
            after, out = nil, []

            loop do
              r = query(**kwd, after: after || true)
              r = r.data.user.repositories
              out |= r.nodes

              if (after = r.page_info.end_cursor).nil?
                break
              end
            end

            out.map do |v|
              format(v)
            end
          end
        end
      end
    end
  end
end
