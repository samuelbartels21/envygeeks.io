# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

Jekyll::Hooks.register [:pages, :documents, :posts], :post_render do |d|
  html = Nokogiri::HTML.parse(d.output)
  html.search("a").each do |t|
    next unless t["href"] =~ %r!(https?:)?//!
    host = d.site.config["hostname"] || d.site.data["hostname"]
    next if URI.parse(t["href"]).hostname == host

    t["rel"] = "noreferrer"
    t["rel"] = t["rel"] + " noopener"
    t["target"] = "_blank"
  end

  d.output = html.to_html
end
