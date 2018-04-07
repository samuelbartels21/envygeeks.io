# Frozen-String-Literal: true
# Copyright 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

module Jekyll
  module Metadata
    module Errors

      # --
      # When there is a problem with GraphQL
      # This mostly happens when vars are not there
      # Keep track of your vars!
      # --
      class GraphQL < StandardError
        def initialize(obj)
          err = obj.errors.messages
          err = err.values.flatten.join("\n  ")
          super err
        end
      end

      # --
      # When the user doesn't provide a token.
      # You can set the token with ENV["GITHUB_TOKEN"]
      # @example GITHUB_TOKEN=blah jekyll b
      # --
      class NoToken < StandardError
        def initialize
          super "No `GITHUB_TOKEN' on `ENV'"
        end
      end
    end
  end
end
