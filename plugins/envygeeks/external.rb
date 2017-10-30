# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

module EnvyGeeks
  # --
  # Searches for external links and makes them open
  class External
    def initialize(doc)
      @doc = doc
    end

    def render
      out = Nokogiri::HTML.parse(@doc.output)
      out.search("a").each do |t|
        next unless t["href"] =~ %r!(https?:)?//!
        t.set_attribute("rel", "noreferrer noopener")
        t.set_attribute("target", "_blank")
      end

      @doc.output = out
        .to_html
    end
  end
end

#

Jekyll::Hooks.register [:pages, :documents, :posts], :post_render do |doc|
  EnvyGeeks::External.new(doc).render
end
