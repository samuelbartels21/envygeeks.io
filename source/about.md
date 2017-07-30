---
url-id: 90fce2ed
id: 9d7858a7-4da6-482e-99be-2298aa4e9559
title: About Me
nav:
  title: About
---

Hey, I'm Jordon Bedwell. You probably don't know me, but I do a lot of open
source work, and I also freelance for a lot of companies who have products you
might have used on a daily basis.

{% img
  giphy/8Anv5VHRlm5vG.gif
  width:100% height:auto
%}

In the past it was my day to day job to scale and grow things like Jekyll builds to thousands of builds with Docker.  No, not at Github, somewhere else. When doing freelance work most people hire me to do initial ops work, Rails apps and even systems programming with languages like Go.  If you were to ask me what I do, I would say I "hack" because I work on many things...

I am heavy Docker user who has built tools like [Docker Template](https://github.com/envygeeks/docker-template){:target="_blank"}{:rel="noreferrer noopener"}, and I currently manage hundreds of Docker images (at least last I checked.) Some very popular and some not so popular.  Did I mention that I am a maintainer of Jekyll too?

Other than that, I can't stand long walks on the beech, WIFI/Cell is spotty, and most beaches are noisey and light polluted now days.  I'd rather spend my time gazing at the stars with a telescope, learning and discussing Space, Systems and Programming, or reading dystopian books to prepare for when Donald Trump becomes President.  I've gotta prepare for the end-times, Winter is coming, if it's not already here.

{% img giphy/GgbCiS1rMjGFy.gif
  width:100% height:auto
%}

## Some Projects

<div class="projects">
  <ul>
    {% for project in site.data.projects %}
      <li>
        <div class="left">
          <a href="{{ project.url }}" target="_blank" rel="noopener noreferrer">
            {{
              project.name
            }}
          </a>
        </div>

        <div class="right">
          <a href="{{ project.url }}/fork" target="_blank" rel="noopener noreferrer">
            <i class="fa fa-code-fork" aria-hidden="true">
              <!-- Empty -->
            </i>
          </a>
        </div>
      </li>
    {% endfor %}
  </ul>
</div>
