---
title: About Me
nav:
  title: About
---

Hi! I'm Jordon Bedwell.  I'm do systems and programming, and I mostly do backend ops work.  On a day to day basis my job is to scale and grow things like Jekyll builds to thousands of builds with Docker.  No, not at Github, somewhere else. When doing freelance work (I am available for hire) most people hire me to do initial ops work, Rails programming and even systems programming with languages like Go and Rust.  If you were to ask me what I do, I would say I "hack" because I work on many things... that are in the backend, I don't deal with frontends that much and now days I spend most of my time building solutions around Docker, including finding ways to make Docker Images ultra easy to use for just about anybody.

I am heavy Docker user who has built tools like [Docker Template](https://github.com/envygeeks/docker-template){:target="_blank"}{:rel="noreferrer noopener"}, and I currently manage hundreds of Docker images (at least last I checked.)  Some very popular and some not so popular.  Did I mention that I am a maintainer of Jekyll too?

Other than that, I can't stand long walks on the beech, WIFI/Cell is spotty, and most beaches are noisey and light polluted now days.  I'd rather spend my time gazing at the stars with a telescope, learning and discussing Space, Systems and Programming, or reading dystopian books to prepare for when Donald Trump becomes President.  I've gotta prepare for the end-times, Winter is coming, if it's not already here.

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
