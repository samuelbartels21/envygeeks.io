# Frozen-String-Literal: true
# Copyright 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require "nokogiri"
module Jekyll
  class StripRouge
    SEARCH = ".//*[contains(@class,'highlighter-rouge')]"
    STRIPS = %r!\s*highlighter-rouge\s*!

    # --
    # Registers the hook.
    # @return [nil]
    # --
    def self.setup
      Jekyll::Hooks.register [:pages, :documents, :posts], :post_render do |v|
        run_with(v)
      end
    end

    # --
    def self.run_with(document)
      log; (html = parse(document.output)).search(SEARCH).each do |v|
        v["class"] = (v["class"].strip.gsub!(STRIPS, "") \
          + " code").strip
      end

      document.output =
        html.to_html
    end

    # --
    # Log our action.
    # @return [nil]
    # --
    def self.log
      Jekyll.logger.debug "StripRougeClass" do
        "removing highlither-rogue"
      end
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
Jekyll::StripRouge.setup
