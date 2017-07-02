---
url-id: 4548de05
id: bfa09146-5b83-43b9-9208-65a13ad2e9a4
title: Using `html-pipeline` in Jekyll.
tags:
  - jekyll
  - ruby
---

With the Jekyll team pretty much having rejected my idea on custom markdown based on the notion that they "have them all" (which is actually wrong but whatever.) I had to think of a way to get `html-pipeline` to replace the built in Markdown processors they had.  This reduced several hacks that were needed to get better Pygments and even gives me the flexibility to add just about anything I want to the pipeline of my content.

## Removing Jekyll's Markdowns.

Instead of patching their classes or even caring about what they had going on I decided it was best to probably just remove their Markdown processors by changing the extension to something I would probably never use.  In this case I chose `.jekyll`.  I also decided to disable their Pygments support too.

```yaml
pygments: false
markdown_ext: jekyll
```

## Build our Pygments processor.

The Pygments processor already built into `html-pipeline` is a great feature already but I had decided that if I ever wanted to go back to Octopress I should probably keep my site backwards with their core syntax for highlighting, especially since I had also already cleaned up and ported it into my site. The key things I wanted to keep from Github's built-in processor was the timeout handling but I want to also add in the "Octopress" style `figure` elements.

```ruby
module HTML
  class Pipeline
    class PygmentsFilter < Filter
      Templates = {
        :line_number => %{<span class="line-number">%s</span>\n},
        :code_line => '<span class="line">%s</span>',
        :code_wrapper => <<-HTML
          <figure class="code">
            <div class="highlight">
              <table>
                <tbody>
                  <tr>
                    <td class="gutter">
                      <pre>%s</pre>
                    </td>
                    <td class="code">
                      <pre><code class="%s">%s</code></pre>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </figure>
        HTML
      }

      # --
      # Searches for the Pygments lexer and then attempts to highlight
      # caching the timeout (if one happens) and just moves along as if
      # nothing ever happened (by not highlighting your code of course.)
      # Then it wraps it in what I hope is close to Octopress style
      # `figure`
      # --
      def call
        doc.search("pre").each do |node|
          next unless lexer = Pygments::Lexer[node["lang"]]
          if out = highlight_without_timeout(lexer, node.inner_text)
              .match(/<pre>(.+)<\/pre>/m)[1]

            code = wrap_lines_and_create_numbers(out)
            node.replace Templates[:code_wrapper] % [
              code[:line_numbers],
              node["lang"],
              code[:code]
            ]
          else
            next
          end
        end

        doc
      end

      # --
      # Does what it says, what the else do you need to know?
      # --
      def highlight_without_timeout(lexer, text)
        lexer.highlight(
          text
        )

      rescue Timeout::Error => boom
        nil
      end

      # --
      # Loop through each line of a Pygments highlighted code block and
      # wrap it with a span that tells us it's a line number and add the
      # index so people know which line of code they are reading.
      # --
      def wrap_lines_and_create_numbers(lines)
        code, line_numbers = "", ""

        lines.each_line.with_index(1) do |l, i|
          code+= Templates[:code_line] % l
          line_numbers+= Templates[
            :line_number
          ] % i
        end

        {
          :code => code,
          :line_numbers => line_numbers
        }
      end
    end
  end
end
```

*Note: That might not be exactly how Octopress does it, considering my site has changed over the years, so it might be slightly different, it isn't that hard to make it exactly the same though.*

## Building the `html-pipeline` generator.

The next part of my task was to build the actual generator.  I wanted to do this in a way that would allow me to extend it without disrupting an already existing configuration file.   So I opted to stick with a `hash` for all so that if I added in anything more than the `:gfm` option it would not inerrupt anything users have already done.

I also did not want to give people the ability to select what types of filters they had... yet, at least until I wanted to take the time to see what all did what and build a pre-approved list that could act as basic security.  So I ended up with the following:

```ruby
module Jekyll
  module Converters
    class Pipeline < Converter
      safe true

      FILTERS = [
        HTML::Pipeline::MarkdownFilter,
        HTML::Pipeline::AutolinkFilter,
        HTML::Pipeline::PygmentsFilter,
      ]

      # --
      # Make sure we have some default options.
      # @return [Hash]
      # --
      def ensure_default_opts
        @config["pipeline"] ||= {}
        @config["pipeline"]["exts"] ||= "github_markdown"
        @config["pipeline"]["opts"] ||= {}
      end

      # --
      # Setup HTML Pipeline
      # --
      def setup
        unless @setup
          ensure_default_opts
          @parser = HTML::Pipeline.new(FILTERS)
          @setup = true
        end
      end

      # --
      # The extension we match.
      # --
      def output_ext(ext)
        ".html"
      end

      # --
      # The extension we match.
      # --
      def matches(ext)
        ext =~ /\.(#{@config["pipeline"]["exts"]})\Z/
      end

      # --
      # Convert the content to HTML.
      # @return [String]
      # --
      def convert(content)
        gfm = @config["pipeline"]["opts"]["gfm"]
        setup; @parser.call(content, :gfm => gfm)[:output].to_s
      end
    end
  end
end
```

After I threw all that into the `_plugins` folder and went on about my way and did a `jekyll build` it immediately let `html-pipeline` take over and do it's job.  I was quite please to say the least.  And with all that said, I hope that you too will switch to `html-pipeline` because it will allow you to adjust your content on the fly a lot easier than Jekyll allows you to.
