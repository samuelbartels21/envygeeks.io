---
url-id: 38d91276
id: 38d91276-6b2c-45cb-b0b9-bd9efaed9d3
description: "Jekyll Assets 3.x has been released, here's what's new."
title: "Jekyll Assets 3.x has been released, here's what's new."
tags: [jekyll, jekyll-assets]
---

Today, Jekyll Assets 3.0.0 has been released 🎂. It involved a major rewrite, for a sponsored feature (SourceMaps,) and a major speed boost, with a major boost to people's ability to make plugins that hook into Jekyll-Assets, in the future.  Here is what's new:

<!-- MORE -->

<!-- TOC depthFrom:2 depthTo:2 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Super Fast](#super-fast)
- [Drop in replacement](#drop-in-replacement)
- [Sprockets 4.x Support](#sprockets-4x-support)
- [Responsive Image Support](#responsive-image-support)
- [Support for `<video>` and `<audio>`](#support-for-video-and-audio)
- [Support for fast `cp`, with `raw_precompile`](#support-for-fast-cp-with-rawprecompile)
- [Support for native `<img asset>`](#support-for-native-img-asset)
- [Better Tag Processing](#better-tag-processing)
- [Proxies in SCSS](#proxies-in-scss)
- [SourceMaps](#sourcemaps)
- [Plugins!](#plugins)
- [Please Donate](#please-donate)

<!-- /TOC -->

## Super Fast

Like the movie, but less funny, and less dumb (in all fairness it wasn't meant to be a serious movie).  Now our system caches much better, we use the manifest more, we more efficiently process, and just, yeah see it for yourself.

```
Configuration file: /srv/jekyll/_config.yml
            Source: ./source
       Destination: ./site
 Incremental build: disabled. Enable with --incremental
      Generating... done in 6.133 seconds.
 Auto-regeneration: enabled for './source'
 LiveReload Server: http://0.0.0.0:35729
    Server address: http://0.0.0.0:4000
  Server running... press ctrl-c to stop.
      Regenerating: 1 file(s) changed at 2017-11-21 11:03:32
        ...done in 2.424920382 seconds.
```

## Drop in replacement

We now support being a direct drop-in replacement for Jekyll's own basic asset processing, but unlike Jekyll, we put the power in your hands, as Jekyll Assets is truly hackable, and extensible, like Jekyll Core, but compared to Jekyll's very basic asset system, we give you flexibility.

***🎉 We now strip `---\n---`, which Jekyll uses to determine assets... 🎉***

### Default Sources

- assets/css
- assets/fonts
- assets/images
- assets/videos
- assets/javascript
- assets/video
- assets/image
- assets/img
- assets/js
- \_assets/css
- \_assets/fonts
- \_assets/images
- \_assets/videos
- \_assets/javascript
- \_assets/video
- \_assets/image
- \_assets/img
- \_assets/js
- css
- fonts
- images
- videos
- javascript
- video
- image
- img
- js

## Sprockets 4.x Support

By default we still default to Sprockets 3.x but now we also support Sprockets 4.x if you are looking for some speed boosts (trust me, it's worth it.) It also enables some of our other features, like SourceMaps, and other features.

```ruby
gem "sprockets", "4.0.beta"
```

## Responsive Image Support

This has been a long standing request from the community.  To support responsive images.  Prior to this rewrite, it would have been a huge undertaking because I never designed 2.x to do the kind of stuff I designed 3.x to do.  Now you can do basic responsive images (and kick on your own advanced responsiveness by going manual on `media` and `sizes`).  You can learn more about how it works here: https://github.com/envygeeks/jekyll-assets#responsive-images

### Example

{% raw %}
```liquid
{% asset img.png @pic
    srcset:max-width="800 2x"
    srcset:max-width="600 1.5x"
    srcset:max-width="400 1x"
      %}
```
{% endraw %}

#### Result

```html
<picture>
  <source srcset="1.png 2x"   media="(max-width:800px)">
  <source srcset="2.png 1.5x" media="(max-width:600px)">
  <source srcset="3.png 1x"   media="(max-width:400px)">
  <img src="img.png">
</picture>
````

### Example

{% raw %}
```liquid
{% asset img.png
    srcset:width="400 2x"
    srcset:width="600 1.5x"
    srcset:width="800 1x"
      %}

{% asset img.png
    srcset:width=400
    srcset:width=600
    srcset:width=800
      %}
```
{% endraw %}

#### Result

```html
<img srcset="1.png   2x, 2.png 1.5x, 3.png   1x">
<img srcset="1.png 400w, 2.png 600w, 3.pnx 800w">
```

## Support for `<video>` and `<audio>`

Sprockets 4 brought better `audio/*` and `video/*` support.  We now support consuming any supported content type, and pushing out a `<video>` or `<audio>`, we've even let you customize the attributes that get passed to them.

## Support for fast `cp`, with `raw_precompile`

in 2.x we had no ability to allow you to quickly copy assets you didn't need to go through the pipline, but wanted inside of your assets folder, this is particularly useful for cases of Emoji systems, where they provide a super huge set of images, but precompiling all those assets even at their most basic through the pipeline is expensive.  You can `cp` these asses quickly now with Jekyll Assets by configuring your project like the following:

```yaml
assets:
  raw_precompile:
  - twemoji/2/svg/1f3c3-1f3fb-200d-2640-fe0f.svg
  - src: twemoji/2/svg/*.svg
    dst: twemoji
```

## Support for native `<img asset>`

Tired of not being able to see your assets when working in Atom Editor or any other editor that has support for markdown previews?  We now support the native image tag with a custom attribute, `<img asset>`. So you can see our assets before they are processed, and then as your site processed, we transform that, it even works with proxies!

### Example

```html
<img src="asset.png" asset>
<img src="asset.png" asset="magick:resize=400">
```

## Better Tag Processing

In 2.x we used a home grown tag parser, and we still do, except now it's extracted into it's own so bugs can be fixed.  And aside from that, it uses Jekyll style standard syntax, with much more powerful handling of arguments. We now support array's, hashes, and it looks more like Jekyll.

{% raw %}
```liquid
{% asset asset.ext key:subkey=val array=1 array=2 %}
```
{% endraw %}

## Proxies in SCSS

You can use proxies within `asset_path` and any other helper provided by Sprockets themselves.  This works the same as the tag arguments, and works the same as `asset_path` except with extra spaces, this even works with global (read: `site`) variables, avoiding the Liquid broke my JavaScript problem with `.css.liquid` or `.liquid.css`, see it in action for yourself

{% raw %}
```scss
body {
  background-image: asset_url("'{{ site.bg }}' magick:resize=1200")
}
```
{% endraw %}


## SourceMaps

We now support SourceMaps.  By default they are only enabled when you have Sprockets 4.x, and they are external, so you use them in production too, if you really want, but we disable them in production.

```yaml
assets:
  source_maps: true
```

## Plugins!

{% raw %}
You can now customize the defaults.  You can disable any default we create by shipping `!attrName`, which will tell us you don't want it, or you can add your own defaults if you want, for example, lets say you want your movies to autoplay, but you don't want to add `@autoplay` to every single `{% asset %}`  You can now create a simple plugin, make sure it's required inside of your Jekyll, and do the following:
{% endraw %}

```ruby
# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module MyNameSpace
  module Assets
    class Default
      class Video < Jekyll::Assets::Default
        content_types "video/avi" "video/webm" "video/mp4"

        # --
        def set_autoplay
          args[:autoplay] = true unless args.key?(:autoplay)
        end
      end
    end
  end
end
```

## Please Donate

Please remember, I'm trying to make a living on OpenSource, if you like my software, <a href="#" class="donate">donate</a> if you can! I never ask people to file pull-requests, and some projects take considerable time, I have no external funding. I also take paid jobs to fix bugs in other peoples OpenSource projects, or to take on features, no matter how large or small.  If you would like to sponsor, please email. Or if you are looking for a full-time, contract or not, full-stack developer, I'm also available for hire.
