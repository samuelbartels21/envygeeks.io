---
title: The Future of My Docker Images
---

This post is going to be as brief as I can.  I hope it will be at least...
There is a big change coming to my Docker images this week and it will disrupt
some and help others, especially those who do ops with my images, or who
have used my images.  It's not that ops was hard with my images, well...
actually they were designed to try and make ops easier.

## Runit won't be running anything

Runit existed with a wrapper script to ease the pains with working with
Docker 1.5/6 that we had.  Those problems have since been fixed and Docker
now sends proper signals and applications respond to those signals. I
always despised having runnit to launch a single process anyways. In my
testing of Docker 1.12 on one of our test servers, it faired very well and I
am happy to finally rid of runnit.  Not that I think it's bad, actually I
love it, I just think it was like having a pneumatic nail-gun to drive a
2d (*1"*) nail.

{% img giphy/2WxWfiavndgcM.gif
  width:100% height:auto
%}

## Sudo will take a larger role until UserNS gets better.

`sudo -u` will replace `chpst` and all processes will now drop to an
unprivileged user this way.  This isn't much of a change but it needs to be
mentioned that this is staying the way it is because UserNS inside of
Docker is still half baked. It needs more work if you ask me.

## Jekyll Docker will have a default CMD

Jekyll Docker will have a better default command, and a lot of it's stuff
will shift out into the background through a setup script.  It will now become
a single process image that just gets stuff done, rather than having runnit
to run a service image.

{% img giphy/MSS0COPq80x68.gif
  width:100% height:auto
%}

I admit this might become a problem for things like bundler, but will it,
really will it? Probably not. Probably not, I actually don't know but it's a
risk I am willing to take and I'll deal with the consequences later.

## When will these changes take affect?

As soon as possible, as in, I will start deploying a few of my images with
these changes and daily more images with changes will continue to roll out.
Some might argue that it will disrupt them, and it will, but I'll argue that
I need to make these changes sometime, and now is as good as any.

{% img giphy/BiWvaZsaYZXoI.gif
  width:100% height:auto
%}
