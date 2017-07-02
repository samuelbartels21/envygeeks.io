---
url-id: 08a9d35e
id: 2299faad-e46f-4454-bc5d-3257b8aa56aa
title: "Postmortem: A tail of how Discourse almost took us out."
tags:
  - discourse
  - postmortem
  - jekyll
---

Today at 10:30AM CST I was alerted to a possible ongoing situation with https://talk.jekyllrb.com, an outage that was quickly escalating out of control because of resources being consumed, CPU steal time, mixed with SideKiq, mixed with a volatile race in `kswapd0`.

Before we start, here are the specs that it is allowed to consume on my cluster:

- Unlimited storage space.
- 2 CPU's, 4 Burst (20/20 Bursted Rest).
- 4GB of memory.

# TL;DR

This morning we noticed that Sidekiq had 13K jobs, it quickly escalated to 14K and then 17K and kept growing, for reasons we do not understand yet.  We know this was initially cause by a large backlog of emails that needed to be sent because of exceptions that were occurring due to [this bug](https://meta.discourse.org/t/sidekiq-email-error-no-implicit-conversion-of-nil-into-string/40419), this is when things got interesting, and got wildly out of control.

# The start

At 10:30AM I was alerted to a minor escalating issue with Jekyll Talk.  The services were restarted as per usual (which normally resolves most Discourse problems.)  It was assumed to be fixed at that time based on past history, and I moved on to other issues on my plate for the day.  Such as my up comming super secret project to be released Monday.

# Then interesting part

Shortly after that at about 11:00AM I was again alerted, that `kswapd0` was consuming 200% of the CPU's, the CPU steal time was at 82% (constantly for the last 20 minutes) and that the load was at 6.23.  The bot then alerted me that Sidekiq had escalating jobs being queued and was also trying to consume a high amount of CPU, but it was battling against `kswapd0`, and Unicorn, a battle it won against Unicorn, but lost out against `kswapd0`.

***ProTip: If `kswapd0` starts causing problems on your server, just drop all the caches on your server after syncing, it'll resolve the problem for you.***

We let it go for an hour in the hopes that the Queue would finish out, however it didn't, it just kept climbing.  So at 1:00PM CST we stopped all the instances, booted the Redis instance alone and flushed all of the databases, which brought Jekyll Talk back up immediately and resolved the entire problem. It was at that time we decided to go ahead and take it down again, so we could also take a minute to upgrade the image to the latest version of Discourse we had released, which took about 1 minute, but then we were a victim of a bug that for some reason had surfaced... where our Discourse images didn't install the Discourse Gems right... or at all (see: envygeeks/docker/issues/8) So we had to rebuild those images. That didn't take that long.  No big deal, I can push those images out within 5 minutes from my laptop... so I did.

We still had one problem though, the CPU steal time for that cluster was still running at 80%, it's a budget cluster at AWS.  So it took Jekyll Talk another hour to boot up and compile resources (something I attribute to both Discourse and the CPU steal time, even on a good day with all the resources it can consume... Discourse takes a good 20 minutes to precompile... which is insane.)

# The End

The site is back up, it's running, it's still a little slow as we still have some locks on some processes for the next 48 hours in-case something goes wrong. Later tonight the Unicorn Web stuff will unlock and it will get free reign of the CPU over anything else... which will bring the site back up to speed.  During this 48 hours period we are also monitoring what the processes do in the hopes that we can find out what actually caused this problem so that we can work with Discourse in solving it... or if we need to adjust the way we move and host Discourse, but in reality, it only ever seems to be talk.jekyllrb.com that has problems... I don't even understand it.
