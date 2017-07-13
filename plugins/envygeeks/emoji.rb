# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require "nokogiri"
require "jekyll/assets"
require "gemoji"

module EnvyGeeks
  class Emoji
    extend Forwardable::Extended

    rb_delegate :sprockets, :to => :site
    rb_delegate :manifest, :to => :sprockets
    rb_delegate :site, :to => :@doc

    IGNORED = %w(pre code tt).freeze
    BASEATTR = %{src="%s" alt="%s" width="20" height="20" align="absmiddle"}
    IMAGE_WITH_INTEGRITY = %Q{<img #{BASEATTR} integrity="%s">}
    IMAGE = %Q{<img #{BASEATTR}>}
    Emojis = ::Emoji

    # --
    # Initialize a new instance.
    # --
    def initialize(doc)
      @frag = Nokogiri::HTML.parse(doc.output)
      @doc = doc
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

      @doc.output = @frag.to_html
    end

    # --
    # Build the base Regexp.
    # --
    private
    def regexp
      return @regexp if @regexp
      emojis = Emojis.all.map(&:aliases).flatten
      emojis = emojis.sort.map { |name| Regexp.escape(name) }
      @regexp = /:(#{emojis.join("|")}):/
    end

    # --
    # Filter the content out.
    # @return [Node]
    # --
    private
    def filter_content(txt)
      if txt =~ regexp
        txt = txt.gsub(regexp) do |match|
          img_tag(match.gsub(/^:|:$/, ""))
        end
      end

      txt
    end

    # --
    # Build the HTML tag.
    # --
    private
    def img_tag(data)
      emoji = Emojis.find_by_alias(data)
      emoji = emoji.image_filename.prepend("emoji/")
      image = manifest.find(emoji).first

      if image
        manifest.used << image
        path = sprockets.digest?? image.digest_path : image.logical_path
        path = sprockets.prefix_path(path)

        if sprockets.asset_config["features"]["integrity"]
          return format(IMAGE_WITH_INTEGRITY, path, \
            image.integrity, data)
        end

        return format(IMAGE, path, data)
      end

      ""
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

Jekyll::Assets::Hook.register(:env, :init) { append_path(Emoji.images_path) }
Jekyll::Hooks.register [:pages, :documents, :posts], :post_render do |doc|
  EnvyGeeks::Emoji.new(doc).parse if EnvyGeeks::Emoji.emojiable?(doc)
end
