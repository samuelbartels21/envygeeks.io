# Frozen-string-literal: true
# Copyright: 2016 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  class GithubGraphQLMeta
    TheKlass = Github::GraphQL::Meta

    # --
    def self.site_pr(s, p)
      gith = TheKlass.new(s)
      p.merge!({
        "git"   => TheKlass::Drop.new(gith.repo),
        "repos" => TheKlass::Drop.new(gith.repos.map do |v|
          TheKlass::Drop.new(v)
        end),
      })
    end

    # --
    def self.page_pr(o, p)
      path = Pathutil.new(o.site.source).relative_path_from(Pathutil.pwd)
      path = path.join(o.respond_to?(:realpath) ?
        o.realpath : o.relative_path)

      gith = TheKlass.new(o.site)
      if path.file?
        stat = gith.stat(path)
        p["meta"] = {
          "github" => TheKlass::Drop.new(stat),
        }
      end
    end

    # --
    def self.setup
      Jekyll::Hooks.register(:site, :pre_render, &method(:site_pr))
      Jekyll::Hooks.register(%i(pages documents),
        :pre_render, &method(:page_pr))
    end
  end
end

# --
Jekyll::GithubGraphQLMeta.setup
