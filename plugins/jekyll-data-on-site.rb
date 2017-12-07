# Frozen-string-literal: true
# Copyright: 2016 - 2017 - MIT License
# Encoding: utf-8

require "jekyll"

module Jekyll
  class DataOnSite
    # --
    # Registers the hook.
    # @return [nil]
    # --
    def self.setup
      Jekyll::Hooks.register :site, :pre_render do |_, v|
        run_with(v)
      end
    end

    # --
    def self.run_with(payload)
      if payload.site.data.key?("site")
        log; payload.site.merge!(payload.site.data["site"])
      end
    end

    # --
    # Log our action.
    # @return [nil]
    # --
    def self.log
      Jekyll.logger.debug("DataOnSite") do
        "merging {{ site.data }} into {{ site }}"
      end
    end
  end
end

# --
Jekyll::DataOnSite.setup
