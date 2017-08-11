# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require "addressable"
module EnvyGeeks
  module Filters
    extend Forwardable::Extended
    rb_delegate :config, {
      to: :site
    }

    # --
    # Allows you to output the class.
    # @note this exists because Jekyll & Liquid have terrible debugging.
    # @note this is seriously for debugging only.
    # @return [String] the class name.
    # --
    def klass(obj)
      obj.class.to_s
    end

    # --
    # Allows you to extract the keys.
    # @param obj [Array,Hash] the array or hash to key
    # @return [Array] the keys
    # --
    def keys(obj)
      return obj if obj.is_a?(Array)
      raise ArgumentError, "must be a hash or array" if !obj.is_a?(Hash)
      obj.keys
    end

    # --
    # Allows you to extract the values.
    # @param obj [Array,Hash] the array or hash to value
    # @return [Array] the values
    # --
    def vals(obj)
      return obj if obj.is_a?(Array)
      raise ArgumentError, "must be a hash or array" if !obj.is_a?(Hash)
      obj.values
    end

    # --
    # Allows you to reverse an array.
    # @param ary [Array] the array to reverse.
    # @return [Array] the reversed array.
    # --
    def reverse(ary)
      if !ary.is_a?(Array)
        raise ArgumentError, "must be an array"
      end

      ary.reverse
    end

    # --
    # Reverse, Reverse and organize by waterfall.
    # @param array [Array] the array to turn into a waterfall.
    # @param posts [true|false] are they posts?
    # @return the waterfalled array
    # --
    def waterfall(object)
      if !object.is_a?(Array) && !object.is_a?(Hash)
        raise ArgumentError, "must be an Array or Hash of Array"
      end

      if object.is_a?(Hash)
        return object.each do |k, v|
          object[k] = waterfall(v)
        end
      end

      one, two = [], []
      return object if object.size == 1
      object = object.sort_by { |v|  v.size rescue v["title"].size }
      object.each_with_index { |v, i| i.odd?? one.unshift(v) : two.push(v) }
      return two | one
    end

    # --
    # Deal with dates in a clean way.
    # @param doc [Jekyll::Document] the document to get the date from.
    # @return [String] the formatted `DateTime`.
    # --
    def modified_or_xmldate(doc)
      return date_to_xmlschema(doc["date"]) if doc["date"]
      path = @context.registers[:site].in_source_dir(doc["path"])
      return date_to_xmlschema(File.stat(path).mtime) if File.exist?(path)
      date_to_xmlschema(Time.now)
    end

    # --
    # Build a canoical URL for the current page.
    # @param [<Anything>] page the page object to work on.
    # @return [String]
    # --
    def canonical_url(page)
      url = page.respond_to?(:url) ? page.url : page["url"]
      url = base_prefix + url

      return url if url == "/"
      return "/" if url == ""

      url.gsub(/\.html$/, ""). \
        gsub(/(?<!http:|https:)\/{2}/, "/"). \
        gsub(/\/$/, "")
    end

    # --
    # Strip the ".html" and "/" from a URL
    # @param url [String] the string you wish to make pretty.
    # @return [String] the prettified url.
    # --
    def pretty(url)
      url.to_s.gsub(/\/$/, ""). \
        gsub(/\.html$/, "")
    end

    # --
    # Ordanalized time, st, nd.
    # @param time [DateTime] the date time.
    # @param archive [true|false] whether this is for the archive.
    # @return [String] the time string ordinalized.
    # --
    def ordinalize(time)
      return "" unless time.is_a?(DateTime) || time.is_a?(Time)
      day = time.strftime("%d")

      tsx = "st" if day.end_with?("1")
      tsx = "nd" if day.end_with?("2")
      tsx = "rd" if day.end_with?("3")
      tsx = "th" if day.end_with?("4") || day.end_with?("5")
      tsx = "th" if day.between?("11", "20")
      time.strftime("%A, %B %d#{tsx}, %Y")
    end

    # --
    # Markdownify a string.
    # This allows me to makdownify titles.
    # @param string [String] the string to markdownify.
    # @return [String]
    # --
    def markdownify_title(string)
      return "" unless string.is_a?(String)
      raise ArgumentError, "invalid input" if string.match(/\n{2}/)
      method = Jekyll::Filters.instance_method(:markdownify).bind(self)
      method.call(string).gsub(/<\/?p>/, "")
    end

    # --
    # Get the base URL.
    # --
    private
    def base_prefix
      port = config["port"]
      serving = config["serving"]
      dev  = Jekyll.env == "development"
      ssl  = config["ssl"]
      base = site.baseurl

      host = dev ? "localhost" : config["host"]
      proto = config["force-ssl"] || (!dev && ssl) ? "https" : "http"
      return format("%s://%s/%s:%s", proto, host, base, port) if serving && base
      return format("%s://%s:%s", proto, host, port) if serving
      format("%s://%s/%s", proto, host, base)
    end

    # --
    # It's all a joke, really it is.
    # @see https://github.com/jekyll/jekyll/pull/6250
    # @see https://github.com/jekyll/jekyll/issues/6249
    # This fixes that problem.
    # --
    private
    def site
      @context.registers[:site]
    end
  end

  Liquid::Template.register_filter(Filters)
end
