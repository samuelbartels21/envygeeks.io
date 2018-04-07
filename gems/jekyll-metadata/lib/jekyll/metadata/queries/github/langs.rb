# Frozen-string-literal: true
# Copyright: 2017 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Metadata
    module Queries
      module Github
        class Langs < Query
          QUERY = CLIENT.parse(DIR.join("github/langs.graphql").read)::Langs

          # --
          # Format the results from #run
          # @param result [GraphQL::Client::Result] the results
          # @param data [Private<Private>] private
          # @return [Array]
          # --
          def self.format(r, data = r.data.repository.languages)
            data.nodes.to_a.map do |v|
              v.name.downcase
            end
          end

          # --
          # @param [Hash] the original out
          # Formats the output into popularity, and uniq
          # @return [Hash]
          # --
          def self.format_out(out)
            out[:all].tap do |o|
              o.each do |v|
                out[:popularity][v] ||= 0
                out[:popularity][v]  += 1
              end
            end.uniq!
            out
          end

          # --
          # Loops over results to get all the results.
          # @return [Hash] see #format
          # --
          def self.loopable_run(**kwd)
            out = {
              all: [],
              popularity: {
                #
              },
            }

            Repos.run.each do |v|
              a, m = nil, nil

              loop do
                r = query({
                  **kwd,
                  after: a || true,
                  user: v[:owner][:login],
                  repo: v[:name],
                })

                m = m ? merge_results(m, r) : r
                r = r.data.repository.languages
                if (a = r.page_info.end_cursor).nil?
                  break
                end
              end

              m = format(m)
              out[:all].concat(m)
            end

            format_out(out)
          end
        end
      end
    end
  end
end
