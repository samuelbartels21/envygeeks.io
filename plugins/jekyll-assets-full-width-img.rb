# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    class FullWidthImg < Jekyll::Assets::Default
      content_types %r!image/[a-zA-Z]+!

      # --
      def set_width
        unless args.key?(:width)
          args[:width] = "100%"
        end
      end

      # --
      def set_height
        unless args.key?(:height)
          args[:height] = "auto"
        end
      end
    end
  end
end
