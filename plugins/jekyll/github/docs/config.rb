# Frozen-string-literal: true
# Copyright: 2016 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Github
    module Docs
      module Config module_function
        def setup
          Jekyll::Hooks.register :site, :after_init do |v|
            v.config["docs"] ||= {}
            v.config["docs"]["disallowed"] ||= []
            v.config["docs"]["allowed"] ||= []
          end
        end
      end
    end
  end
end

# --
Jekyll::Github::Docs::Config.setup
