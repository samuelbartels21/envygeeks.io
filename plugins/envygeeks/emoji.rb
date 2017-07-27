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
    ATTR = %{src="%s" alt="%s" width="20" height="20" align="absmiddle"}.freeze
    IMAGE_INTEGRITY = %Q{<img #{ATTR} integrity="%s">}.freeze
    IMAGE = %Q{<img #{ATTR}>}.freeze
    Emojis = ::Emoji

    # --
    # Initialize a new instance.
    # @param doc [Jekyll::Document] the document to parse.
    # @return self
    # --
    def initialize(doc)
      @frag = Nokogiri::HTML.parse(doc.output)
      @doc  = doc
    end

    # --
    # @return nil
    # Parse, search for Emoji's and then replace the
    # documents output.
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
    # @private
    # --
    private
    def regexp
      return @regexp if @regexp
      emojis = Emojis.all.map(&:aliases).flatten
      emojis = emojis.sort.map { |name| Regexp.escape(name) }
      @regexp = /:(#{emojis.join("|")}):/
    end

    # --
    # @return [Node]
    # @param txt [TextNode] the text node to replace.
    # Filter the content out.
    # @private
    # --
    private
    def filter_content(txt)
      if txt =~ regexp
        txt = txt.gsub(regexp) do |match|
          img(match.gsub(/^:|:$/, ""))
        end
      end

      txt
    end

    # --
    # @return [true,false]
    # Whether or not integrity is enabled.
    # @private
    # --
    private
    def integrity?
      sprockets.asset_config["features"]["integrity"]
    end

    # --
    # Build the HTML tag.
    # @param data [String] the data.
    # @return [String] string.
    # @private
    # --
    private
    def img(data)
      emoji = Emojis.find_by_alias(data)
      emoji = emoji.image_filename.prepend("emoji/")
      image = manifest.find(emoji).first
      return "" unless image

      manifest.used << image
      path = sprockets.digest?? image.digest_path : image.logical_path
      path = sprockets.prefix_path(path)
      intg = image.integrity

      # <img integrity=val>, broken?
      return format(IMG2, path, ingt, data) if integrity?
      format(IMG1, path, data)
    end

    class << self

      # --
      # @return [true,false] whether it can be emojified.
      # @param doc [Jekyll::Document,Jekyll::Page,Jekyll::Post] the document
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
