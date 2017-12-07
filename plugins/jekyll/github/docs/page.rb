# Frozen-string-literal: true
# Copyright: 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Github
    module Docs
      class Page < Jekyll::Document
        def read_content(*)
          @content
        end
      end
    end
  end
end
