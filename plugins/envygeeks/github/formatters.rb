# Frozen-String-Literal: true
# Copyright 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

module EnvyGeeks
  class Github
    module Formatters
      module_function

      # --
      # rubocop:disable Metrics/AbcSize
      # Formats repo/repos result into a useable hash. This
      #   is shared logic between repo and repos so that there
      #   is no duplication since they pretty much share the
      #   same data, either in an array or just the result.
      # @return [{}] the formatted hash.
      # --
      def repo(result)
        {
          name:     result.name,
          pushed:   DateTime.parse(result.pushed_at),
          language: result.primary_language.name,
          rel:      result.name_with_owner,
          url:      result.url,

          counts: {
            issues: result.issues.total_count,
            pulls:  result.pull_requests.total_count,
            stars:  result.stargazers.total_count,
            forks:  result.forks.total_count,
          },

          owner: {
            login:   result.owner.login,
            website: result.owner.fetch(:websiteUrl) { nil },
            name:    result.owner.fetch(:name) { result.owner.org },
            url:     result.owner.url,

            avatar: {
              url: result.owner.avatar_url,
              rel: Helpers.strip(result.owner
                .avatar_url),
            },
          },
        }
      end

      # --
      # @return [Array<{}>] an array of commits.
      # Loops on the commits and returns them as an array of commits.
      # @param result [@todo] the results.
      # --
      def commit(result)
        {
          url:       result.commit_url,
          date:      DateTime.parse(result.committed_date),
          message:   result.message_headline,
          tree_url:  result.tree_url,
          oid:       result.oid,

          author:    {
            name:    result.author.user.name,
            website: result.author.user.website_url,
            login:   result.author.user.login,
            url:     result.author.user.url,

            avatar: {
              url: result.author.user.avatar_url,
              rel: Helpers.strip(result.author.user
                .avatar_url).to_s,
            },
          },
        }
      end
    end
  end
end
