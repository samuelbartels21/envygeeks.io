# Frozen-String-Literal: true
# rubocop:disable Style/SpecialGlobalVars
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

if Jekyll.env != "development"
  Jekyll::Hooks.register :site, :post_write, priority: 99 do |_|
    `script/minify`

    if $?.exitstatus != 0
      Jekyll.logger.error("Unable to Minify")
    end
  end
end
