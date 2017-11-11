# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

if Jekyll.env != "development"

  # --
  # We need this to remain 99 because if it doesn't then
  # there will be problems with things like livereload, which should
  # really prioritize themselves as being the very last.
  # rubocop:disable Style/SpecialGlobalVars
  # --
  Jekyll::Hooks.register :site, :post_write, priority: 99 do |_|
    `script/minify`

    if $?.exitstatus != 0
      Jekyll.logger.error("Unable to Minify")
    end
  end
end
