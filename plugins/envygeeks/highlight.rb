# Frozen-String-Literal: true
# Copyright 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require "nokogiri"

module EnvyGeeks
  class Highlight
    SEARCH = ".//div[contains(@class, 'highlighter-rouge')]".freeze

    # --
    # Takes in a document, makes a fragment.
    # @param doc [Jekyll::Document] the document.
    # @return self
    # --
    def initialize(doc)
      @frag = Nokogiri::HTML.parse(doc.output)
      @doc  = doc
    end

    # --
    # Search for and throw out anything that says "highlighter-rouge",
    # because not only is it spelled wrong, but if I move systems that won't
    # exist, so I need to keep my CSS more agnostic and closer to
    # the standard Pygments when it's wrapped.
    # --
    def parse
      @frag.search(SEARCH).each do |v|
        # I don't need a specific class, if I plan to move.
        v["class"]  = v["class"].gsub(/\s*highlighter-rouge\s*/, "")
        v["class"] += " code"
      end

      @doc.output = @frag.to_html
    end
  end
end

# --
# Hook into Jekyll
Jekyll::Hooks.register [:pages, :documents, :posts], :post_render do |doc|
  # Disable in dev so we can spot changes.
  unless Jekyll.env == "development"
    EnvyGeeks::Highlight.new(doc).parse
  end
end
