# Frozen-string-literal: true
# Copyright: 2017 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Metadata
    module Queries
      class Stat < Query
        QUERY = CLIENT.parse(DIR.join("stat.graphql").read)::Stat

        # --
        # @return [Array<Hash>]
        # Format the result.
        # --
        def self.format(r, data = r.data.repository.ref.target.history.nodes, path:)
          if data.any?
            first = data.first
            branch = r.data.repository.ref.name
            data = data.sort_by(&:committed_date)
            url = r.data.repository.url
            last = data.last

            {
              source_url: "#{url}/blob/#{branch}/#{path}",
              updated_at: Time.parse(last.committed_date),
              updated_by: format_author(last.author.user),
              created_by: format_author(first.author.user),
              created_at: Time.parse(first.committed_date),
              edit_url: "#{url}/edit/#{branch}/#{path}",
              history: data.map do |v|
                format_commit(v)
              end,
            }
          else
            {
              created_at: Time.now,
              updated_at: Time.now,
              history: [
                # No
              ],
            }
          end
        end

        # --
        # Format a author.
        # @return [Hash]
        # --
        def self.format_author(v)
          avatar_path = v.avatar_url
            .gsub(%r!https?://(www\.)?github\.com/+!, "")
            .gsub(%r!https?://[^.]+\.githubusercontent\.com/+!, "")
            .gsub(%r!\?v=[0-9]+$!, "")

          {
            login: v.login,
            website: v.website_url,
            name: v.name,
            url: v.url,

            avatar: {
              url: v.avatar_url,
              id: avatar_path.sub(%r!^u/!, ""),
              path: avatar_path,
            },
          }
        end

        # --
        # Format a commit.
        # @return [Hash]
        # --
        def self.format_commit(v)
          {
            message: v.message_headline,
            pushed_at: Time.parse(v.committed_date),
            author: format_author(v.author.user),
            url: v.commit_url,
            oid: v.oid,

          }
        end

        # --
        # @return [Array<Hash>]
        # Loops around run to recurse results.
        # @see #format
        # --
        def self.loopable_run(path:, **kwd)
          after, out = nil, nil

          loop do
            r = query({
              **kwd,
              after: after || true,
              path: path,
            })

            out = out ? merge_results(out, r) : r
            r = out.data.repository.ref.target.history
            if (after = r.page_info.end_cursor).nil?
              break
            end
          end

          format(out, {
            path: path,
          })
        end

        # --
        # Variables for the query.
        # @return [Hash]
        # --
        def self.vars(after: nil, path:)
          super(after: after).merge({
            path: path,
          })
        end
      end
    end
  end
end
