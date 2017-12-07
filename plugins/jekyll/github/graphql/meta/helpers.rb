# Frozen-String-Literal: true
# Copyright 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

module Jekyll
  module Github
    module GraphQL
      class Meta
        module Helpers module_function
          # --
          # Gets the result and loop it back to you.
          # @note this is split out so that it can be used with
          #   or without results, that way you can loop subresults
          #   if you really wish to loop them.
          # @return Class<Results>
          # --
          def loop(results, into: [])
            results.each do |v|
              v = yield v if block_given?

              if v
                into << v
              end
            end

            into
          end

          # --
          # @return [String] the cleaned URL.
          # Strips `https://github.com/` from the URL so that you
          #   can use your own URL, your own redirect or your pathing
          #   scheme, if you really wish.
          # --
          def strip(str)
            str
              .gsub(%r!https?://(www\.)?github\.com/+!, "")
              .gsub(%r!https?://[^.]+\.githubusercontent\.com/+!, "")
              .gsub(%r!\?v=[0-9]+$!, "")
          end

          # --
          # @return [Proc] the headers to set.
          # rubocop:disable Lint/NestedMethodDefinition
          # Returns a proc so that the `EndPoint` can set it's headers.
          # @note It seems that Github/GraphQL doesn't support
          #   auth so we need to add it manually at
          #   that point.
          # --
          def headers
            proc do
              def headers(*)
                {
                  "For"           => "https://envygeeks.io",
                  "License"       => "MIT License - Copyright 2017 Jordon Bedwell",
                  "Library"       => "EnvyGeeks Github GraphQL Query Machine",
                  "Authorization" => "bearer #{TOKEN}",
                  "Auth"          => "bearer #{TOKEN}",
                }
              end
            end
          end

          # --
          # rubocop:disable Lint/UselessAssignment
          # rubocop:disable Style/SpecialGlobalVars
          # Infers the current repository name from the origin.
          #   And if there is no name then it just dumps and fails
          #   because you shouldn't be using this without git.
          # @return [String] the name
          # --
          def info
            @info ||= begin
              remotes = `git remote -v`
              raise "Bad Git Remote: #{remotes.inspect}" if $?.exitstatus != 0
              remotes = remotes.gsub(%r!\((fetch|push)\)$!m, "").split(%r!\s*$\n+!)
                .uniq.keep_if { |v| v.match(%r!github\.com!) }

              remote = remotes[0] if remotes.size == 1
              remote = remotes.find { |v| v.start_with?("origin\t") }
              remote = remote.gsub(%r!^origin\t!, "")
                .gsub(%r!(git@|https?://)github\.com(/|:)!, "")
                .gsub(%r!\.git$!, "").split("/")

              out = {
                user: remote.fetch(0),
                repo: remote.fetch(1),
              }

              out
            end
          end
        end
      end
    end
  end
end
