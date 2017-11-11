# Frozen-String-Literal: true
# Copyright 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require "nokogiri"

module EnvyGeeks
  class Highlight
    # --
    # Takes in a document, makes a fragment.
    # @param doc [Jekyll::Document] the document.
    # @return self
    # --
    def initialize(doc)
      @doc = doc
    end

    # --
    # Search for and throw out anything that says "highlighter-rouge",
    # because not only is it spelled wrong, but if I move systems that won't
    # exist, so I need to keep my CSS more agnostic and closer to
    # the standard Pygments when it's wrapped.
    # --
    def parse
      search = ".//div[contains(@class, 'highlighter-rouge')]"
      @doc.output = Nokogiri::HTML.parse(@doc.output).tap do |o|
        o.search(search).each do |v|
          v["class"].strip!
          v["class"].gsub!(%r!\s*highlighter-rouge\s*!, "")
          v["class"] += " code"
          v["class"].strip!
        end
      end.to_html
    end
  end
end

# --
Jekyll::Hooks.register [:pages, :documents, :posts], :post_render do |doc|
  EnvyGeeks::Highlight.new(doc).parse
end
