# Frozen-string-literal: true
# Copyright: 2017 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Metadata
    module Queries
      class Site < Query
        QUERY = CLIENT.parse(DIR.join("site.graphql").read)::Site

        # --
        # @return [Array<Hash>]
        # Format the result.
        # --
        def self.format(r, data = r.data.repository)
          out = Github::Repos.format(data)
          out[:history] = data.ref.target.history.nodes.to_a.map do |v|
            Stat.format_commit(v)
          end

          out
        end

        # --
        # @return [Array<Hash>]
        # Loops around run to recurse results.
        # @see #format
        # --
        def self.loopable_run(**kwd)
          after, out = nil, nil

          loop do
            r = query(**kwd, after: after || true)
            out = out ? merge_results(out, r) : r
            r = r.data.repository.ref.target.history
            if (after = r.page_info.end_cursor).nil?
              break
            end
          end

          format(out)
        end
      end
    end
  end
end
