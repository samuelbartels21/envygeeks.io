# Frozen-String-Literal: true
# Copyright 2016 Jordon Bedwell - MIT License
# Encoding: UTF-8

require "addressable"
module Filters

  #--
  # DateTime format for HTML5 <time> tag.
  # --
  def tt_datetime(time)
    time.utc.strftime(
      "%Y-%m-%dT%H:%M"
    )
  end

  # --
  # Reverse, Reverse and organize by waterfall.
  # --
  def waterfall(array, posts = false)
    if posts
      array = array. sort_by { |v| v.date.year }.reverse
      array = array.group_by { |v| v.date.year }
      out   = array.map do |_, v|
        _waterfall(
          v
        )
      end

      return (
        out.flatten
      )
    else
      _waterfall(array, {
        :hash => array[0].is_a?(Hash)
      })
    end
  end

  # --
  # Deal with dates in a clean way.
  # --
  def modified_or_xmldate(doc)
    if doc.key?("date") && doc["date"]
      return date_to_xmlschema(
        doc["date"]
      )

    else
      date_to_xmlschema(File.stat(
        @context.registers[:site].in_source_dir(doc["path"])
      ).mtime)
    end
  rescue
    date_to_xmlschema(
      Time.now
    )
  end

  # --
  # Build a canoical URL for the current page.
  # @param [<Anything>] page the page object to work on.
  # @return [String]
  # --
  def canonical_url(page)
    url  = base_prefix
    url += page["url"]

    if url == "/"
      then return(
        url
      )

    elsif url == ""
      then return(
        "/"
      )

    else
      url.gsub(/\.html$/, "").gsub(
        /\/$/, ""
      )
    end
  end

  # --
  # Strip the ".html" and "/" from a URL
  # @return [String]
  # --
  def pretty(url)
    url.to_s.gsub(/\/$/, "").gsub(
      /\.html$/, ""
    )
  end

  # --
  # Pull an avatar from Github.
  # @return [String]
  # --
  def github_avatar(user, width = 80)
    format("https://avatars3.githubusercontent.com/%s?v=3&s=%d",
      user, width.to_i
    )
  end

  # --
  # Ordanalized time, st, nd.
  # @return [String]
  # --
  def fancy_time(time, archive: false)
    return "" unless time.is_a?(DateTime) || time.is_a?(Time)
    day = time.strftime(
      "%d"
    )

    tsx = "st" if day.end_with?("1")
    tsx = "nd" if day.end_with?("2")
    tsx = "rd" if day.end_with?("3")
    tsx = "th" if day.between?(
      "11", "19"
    )

    if archive
      then time.strftime(
        "%A, %B %d#{
          tsx
        }"
      )
    else
      time.strftime(
        "%A, %B %d#{tsx}, %Y"
      )
    end
  end

  # --
  # Fancy time without the year.
  # --
  def archive_time(time)
    time.strftime(
      "%m/%d"
    )
  end

  # --
  # Markdownify a string.
  # @return [String]
  # --
  def markdownify_title(string)
    return "" unless string.is_a?(String)
    Jekyll::Filters.instance_method(:markdownify).bind(self).call(string)
      .gsub(
        /<\/?p>/, ""
      )
  end

  # --
  # Get the base URL.
  # --
  private
  def base_prefix
    if Jekyll.env == "development"
      domain = "http://%s:%s"
      domain = format(domain, *@context.registers[:site].config.values_at("host", "port"))
      domain + @context.registers[:site].config[
        "baseurl"
      ]
    else
      domain = @context.registers[:site].config["base_domain"] || ""
      domain + @context.registers[:site].config[
        "baseurl"
      ]
    end
  end

  # --
  # The actual work behind making a waterfall array.
  # --
  private
  def _waterfall(array, hash: false)
    a, b = [], []

    _a = array.sort_by do |p|
      if hash
        p.fetch("title",
          p["name"]
        )

      else
        p.data[
          "title"
        ]
      end \
      .size
    end

    # Reverse so smallest is last.
    _a.reverse.each_with_index do |p, i|
        i.even?? (a << p) : (
          b << p
        )
      end

    a.reverse | b
  end
end

Liquid::Template.register_filter(
  Filters
)
