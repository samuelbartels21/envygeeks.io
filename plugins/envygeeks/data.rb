# Frozen-string-literal: true
# Copyright: 2016 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Hooks.register :site, :pre_render do |_, p|
  if p.site&.data&.key?("site")
    then p.site.merge!(p.site.data["site"])
  end
end
