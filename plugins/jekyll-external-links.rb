# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# rubocop:disable Style/Next
# Encoding: UTF-8

module Jekyll
  class ExternalLinks
    MATCHER = %r!(https?:)?//!

    # --
    def self.setup
      Jekyll::Hooks.register [:pages, :documents, :posts], :post_render do |v|
        run_with(v)
      end
    end

    # --
    def self.run_with(document)
      (html = parse(document.output)).search("a").each do |v|
        next unless v["href"] =~ MATCHER

        uri = URI.parse(v["href"])
        hostname = document.site.config["hostname"] \
          || document.site.data["hostname"]

        if uri.hostname != hostname
          v["rel"] = "noreferrer"
          v["rel"] = v["rel"] + " noopener"
          v["target"] = "_blank"
        end
      end

      document.output =
        html.to_html
    end

    # --
    def self.parse(html)
      Nokogiri::HTML.parse(html) do |c|
        c.options = Nokogiri::XML::ParseOptions::NONET | \
          Nokogiri::XML::ParseOptions::NOENT
      end
    end
  end
end

# --
Jekyll::ExternalLinks.setup
