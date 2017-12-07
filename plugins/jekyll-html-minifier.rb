# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

module Jekyll
  class HTMLMinifier
    # --
    # Registers the hook.
    # @return [nil]
    # --
    def self.setup
      Jekyll::Hooks.register :site, :post_write, priority: 0 do |_|
        run
      end
    end

    # --
    def self.run
      if Jekyll.env == "production"
        `script/minify`
      end
    end
  end
end

# --
Jekyll::HTMLMinifier.setup
