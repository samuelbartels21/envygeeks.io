# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require "open3"

module EnvyGeeks

  # --
  # Allows you to minify the sites HTML the same way it
  # will be in production so that you get a valid look at
  # how the site will behave, because minification can
  # remove a lot of whitespae.
  # --
  class Minify
    def initialize(input)
      @input = input
    end

    def run
      status, out, err = nil, "", ""
      Open3.popen3("script/minify") do |i, o, e, p|
        i.puts @input; i.close
        out = o.read
        err = e.read

        if !p.value.success?
          out = @input
          if err
            Jekyll.logger.error(
              err
            )
          end
        end
      end

      out
    end
  end
end

# Register and run it.
Jekyll::Hooks.register [:pages, :documents, :posts], :post_render do |doc|
  doc.output = EnvyGeeks::Minify.new(doc.output).run
end
