require "nokogiri"
require "gemoji"

module Jekyll

  # --
  # Integrates Github's Gemoji with Jekyll Assets.
  # Gemoji for Jekyll Assets
  # --
  class Emoji
    IMG1 = %q{<img src="%s" alt="%s" width="20" height="20" align="absmiddle">}
    IMG2 = %q{<img src="%s" integrity="%s" alt="%s" width="20" height="20" align="absmiddle">}
    IGNORED = %w(pre code tt).freeze

    # --
    # Initialize a new instance.
    # --
    def initialize(doc)
      @doc = doc
      @frag = Nokogiri::HTML.fragment(
        doc.output
      )
    end

    # --
    # Parse and return nothing.
    # --
    def parse
      @frag.search('.//text()').each do |node|
        content = node.to_html
        next unless content.include?(":")
        next if IGNORED.include?(node.parent.name.downcase)
        html = filter_content(content)
        next if html == content
        node.replace(html)
      end

      @doc.output = (
        @frag.to_html
      )
    end

    # --
    # Build the base Regexp.
    # --
    private
    def regexp
      return @regexp ||= begin
        emojis = ::Emoji.all.map(&:aliases).flatten.sort.map do |name|
          Regexp.escape(
            name
          )
        end

        /:(#{emojis.join(
          "|"
        )}):/
      end
    end

    # --
    # Filter the content out.
    # @return [Node]
    # --
    private
    def filter_content(txt)
      if txt =~ regexp
        then txt = txt.gsub(regexp) do |match|
          img_tag(match.gsub(
            /^:|:$/, ""
          ))
        end
      end

      txt
    end

    # --
    # Build the HTML tag.
    # --
    private
    def img_tag(data)
      image = @doc.site.sprockets.manifest.find(::Emoji.find_by_alias(data).image_filename
        .prepend("emoji/")).first

      if image
        @doc.site.sprockets.manifest.used << image
        path = @doc.site.sprockets.prefix_path(
          @doc.site.sprockets.digest?? image.digest_path \
            : image.logical_path
        )

        if @doc.site.sprockets.asset_config["features"]["integrity"]
          then format(IMG2,
            path, image.integrity, data
          )

        else
          format(IMG1,
            path, data
          )
        end
      else
        ""
      end
    end

    class << self

      # --
      # Check if a document can be emojified.
      # --
      def emojiable?(doc)
        (doc.is_a?(Jekyll::Page) || doc.write?) && doc.output_ext == ".html" \
          || (doc.permalink && doc.permalink.end_with?("/"))
      end
    end
  end
end

# --

Jekyll::Assets::Hook.register :env, :init do
  append_path(
    Emoji.images_path
  )
end

# --

Jekyll::Hooks.register [:pages, :documents, :posts], :post_render do |doc|
  if Jekyll::Emoji.emojiable?(doc)
    then Jekyll::Emoji.new(doc).parse
  end
end
