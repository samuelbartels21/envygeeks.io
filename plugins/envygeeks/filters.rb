# Frozen-String-Literal: true
# Copyright 2016 - 2017 Jordon Bedwell - MIT License
# Encoding: UTF-8

require "addressable"
module EnvyGeeks
  module Filters
    extend Forwardable::Extended
    rb_delegate :config, {
      :to => :site
    }

    #--
    # DateTime format for HTML5 <time> tag.
    # @param time [DateTime] the time to format.
    # @return [string] the formatted time.
    # --
    def tt_datetime(time)
      time.utc.strftime("%Y-%m-%dT%H:%M")
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

      url.gsub(/\.html$/, "").gsub(/\/$/, ""). \
        gsub(/(?<!http:|https:)\/{2}/, "/")
    end

    # --
    # Strip the ".html" and "/" from a URL
    # @param url [String] the string you wish to make pretty.
    # @return [String] the prettified url.
    # --
    def pretty(url)
      url.to_s.gsub(/\/$/, "").gsub(/\.html$/, "")
    end

    # --
    # Ordanalized time, st, nd.
    # @param time [DateTime] the date time.
    # @param archive [true|false] whether this is for the archive.
    # @return [String] the time string ordinalized.
    # --
    def fancy_time(time, archive: false)
      return "" unless time.is_a?(DateTime) || time.is_a?(Time)
      day = time.strftime("%d")

      tsx = "st" if day.end_with?("1")
      tsx = "nd" if day.end_with?("2")
      tsx = "rd" if day.end_with?("3")
      tsx = "th" if day.between?("11", "20")
      return time.strftime("%A, %B %d#{tsx}") if archive
      time.strftime("%A, %B %d#{tsx}, %Y")
    end

    # --
    # Fancy time without the year.
    # @param time [DateTime] the time to format.
    # @return [String] m/d formatted simply.
    # --
    def archive_time(time)
      time.strftime("%m/%d")
    end

    # --
    # Markdownify a string.
    # This allows me to makdownify titles.
    # @param string [String] the string to markdownify.
    # @return [String]
    # --
    def markdownify_title(string)
      return "" unless string.is_a?(String)
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
  end
end

# --
# Liquid:Register
# Liquid:Filter
# --
Liquid::Template.register_filter(EnvyGeeks::Filters)
