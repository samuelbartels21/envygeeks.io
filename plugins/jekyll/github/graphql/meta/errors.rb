# Frozen-String-Literal: true
# Copyright 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

module Jekyll
  module Github
    module GraphQL
      class Meta
        module Errors
          class GraphQLError < StandardError
            # --
            def initialize(obj)
              super obj.errors.messages.values
                .flatten.join("\n  ")
            end
          end
        end
      end
    end
  end
end
