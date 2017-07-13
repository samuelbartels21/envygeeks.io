# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

module EnvyGeeks
  module Helpers

    # --
    # Provides site to classes that might not have site
    # already defined.  This makes it so that you can use things
    # like Filters without much trouble.
    # --
    module Site
      def site
        @context.registers[:site]
      end
    end
  end
end
