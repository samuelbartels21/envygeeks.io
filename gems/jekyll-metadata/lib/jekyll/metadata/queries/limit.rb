# Frozen-string-literal: true
# Copyright: 2017 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Metadata
    module Queries
      class Limit < Query
        QUERY = CLIENT.parse(DIR.join("limit.graphql").read)::Limit

        # --
        # @return [false]
        # @note don't cache
        # This is fast
        # --
        def self.cacheable?
          false
        end

        # --
        # Format the result
        # @param r [GraphQL::Client::Response] the response
        # @param data [<Private>] <Private>
        # @return [Hash]
        # --
        def self.format(r, data = r.data.rate_limit)
          {
            remaining_queries: data.remaining,
            resets_at: Time.parse(data.reset_at),
            limit: data.limit,
          }
        end
      end
    end
  end
end
