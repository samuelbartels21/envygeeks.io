# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

module EnvyGeeks
  module Generators
    class Tags < Jekyll::Generator

      # --
      # Generate your tags as actual pages.
      # --
      def generate(site)
        key = (site.config["tag-layout"] || "default")
        key = key.chomp(".html")

        if site.layouts.has_key?(key)
          site.tags.keys.each do |tag|
            tag = Pages::Tag.new(site, tag)
            tag.render(site.layouts, site.site_payload)
            tag.write(site.dest)
            site.pages.push(tag)
          end

        # This error should be configurable or removed entirely
        # because at the end of the day if there is no default.html
        # or a specific tag layout, the user knows this...

        else
          Jekyll.logger.error "", "Could not find '#{key}.html' " \
            "Skipping tags."
        end
      end
    end
  end
end
