# Frozen-String-Literal: true
# Copyright 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require "nokogiri"

Jekyll::Hooks.register [:pages, :documents, :posts], :post_render do |d|
  html = Nokogiri::HTML.parse(d.output)
  search = ".//*[contains(@class,'highlighter-rouge')]"
  html.search(search).each do |v|
    v["class"].strip!
    v["class"].gsub!(%r!\s*highlighter-rouge\s*!, "")
    v["class"] += " code"
    v["class"].strip!
  end

  d.output = html.to_html
end
