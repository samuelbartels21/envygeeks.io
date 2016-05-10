---
title: Removing Nginx from Jekyll Docker, and other updates
---

Today Jekyll Docker removed Nginx from the image entirely.  In the past it existed solely to make it easy for GitHub Pages users to get almost GitHub pages like behavior, however, in 3.0 we merged updates to serve that did that directly inside of our WEBRick instance so it really isn't necessary anymore, and users who still need it can always wait until next week when I work on the super image to update, this will give you some nice new stuff meant for people who want a one-stop shop for Jekyll on their servers.

## Why remove it, just disable it?

I'm removing it because it does add a bit of weight to the image, and the intention with this image is to always make it as small and pullable as possible.  Update often and update swiftly.  With a large image it can be a pain for people outside of the United States or Europe to get our images.  It doesn't shave much, but it shaves some.

## Other removals

- Python - Both Jekyll and Github pages now default to Rouge.
- RedCarpet - It's no longer available on Github, Kramdown is just as good.
- Pygments.rb - Most of our users are GitHub pages users, it's not available there.
- Maruku - I don't know that we ever even supported it?
- RDiscount - Reinstall it if you need it.

## What is the benefit?

Our image will shrink from 15<i>n</i>MB to a respectable 10<i>n</i>MB and hopefully we can optimize it more as time goes on, but that's a good start, it's back to where we originally wanted it at before we started adding all sorts of work around's and other stuff.

## Silencing Bundler - It's now possible.

One new thing that has been released today (by upstream `envygeeks/{alpine,ubuntu}`) is the ability to now be able to send `SILENCE_BUNDLER=1` and silence your bundle installs, so you can reduce the noise you get when you have a predictable setup.  Such as when you are deploying with our image.  No worries, it only silences `STDOUT` leaving STDERR available for all your errors and debug messages.  So.. if something does go wrong you'll be informed.
