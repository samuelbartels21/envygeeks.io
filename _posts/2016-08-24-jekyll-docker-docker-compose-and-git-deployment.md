---
title: Jekyll, Docker, Docker-Compose, and Git Deployment
tags:
  - jekyll
  - docker-compose
  - docker
---

So, lets assume you've your own server and you've all the extra capacity in
the world to host your site (not that you'll really need much.)  You've got
Docker installed, you've got Docker-Compose installed and now you're ready
to go and start deploying your site with Docker.

***Pro-tip: Make sure you're using seccomp.***

## What you'll need

* A Linux Server
* [Docker-Compose](https://github.com/docker/compose)
* [Docker](https://www.docker.com/products/overview)
* Git

## Setup the Git Repo

<p class="code-file">
  On the Server
</p>

```bash
mkdir -p ~/repos
git init --bare ~/repos/example.com.git
```

## Cleanup the hooks and add post-receive

Now, on your server you'll want to go into `~/repos/example.com.git` and start
to cleanup the `hooks/` folder, I normally just delete everything and add what
I want when I'm ready to add it, there is no reason to keep it there since it
is fairly easy to Google what hooks are currently supported by Git.  Just
do yourself a quick cleanup and `rm hooks/*`

<p class="code-file">
  hooks/post-receive
</p>

```bash
#!/usr/bin/env bash
set -ex

DOMAIN=example.com
TMP_DIR=$(mktemp -d)
VENDOR_DIR=vendor/bundle
GIT_WORK_TREE=$TMP_DIR git checkout -f master
CACHE_DIR=~/caches/srv/jekyll/$VENDOR_DIR
WRITE_DIR=~/static/$DOMAIN
cd $TMP_DIR

# --

mkdir -p $CACHE_DIR
mkdir -p $WRITE_DIR

# --

mkdir -p $VENDOR_DIR
rsync -av --quiet --delete $CACHE_DIR/ $VENDOR_DIR
docker-compose -f compose.yml pull production-build
docker-compose -f compose.yml  run production-build
rsync -av --delete --quiet _site/ $WRITE_DIR
docker-compose -f compose.yml rm -f --all

# --
# Update the caches with the latest stuff that we get when
# building out the current site, this will rarely get updated
# but it does none-the-less, so we need to make sure that we
# keep it updated.
# --

docker-compose -f compose.yml run update
rsync -av --quiet --delete $VENDOR_DIR/ $CACHE_DIR
rm -rf $TMP_DIR
cd -

# --
# Cleanup if the function docker-clean is available.
# This is provided by our server, but there is a public
# version somebody else made somewhere.
# --

docker-clean 2>/dev/null \
  || true
```

## Setup Docker Compose

<p class="code-file">
  compose.yml
</p>

```yml
# --
# When you plan to develop the site.
# CMDS: docker-compose -f docker/compose.yml up/run command.
# NOTE: This is inherited by most of the stuff around here.
#   Except for production.
# --
development: &def
  image: jekyll/jekyll
  restart: never
  environment:
    SILENCE_BUNDLER: 1
    JEKYLL_ENV: development
    BUNDLE_CACHE: 1
  volumes:
    - .:/srv/jekyll
  ports:
    - 4000:4000
  command: "\
    chpst -u jekyll sh -c '\
      rm -rf _site;\
      rm -rf .asset-cache;\
      bundle exec jekyll serve --watch \\\
        --drafts -H 0.0.0.0 --trace
    '\
  "

# --
# Production build.
# This is used in our deploy scripts.
# --
production-build:
  <<: *def
  environment:
    SILENCE_BUNDLER: 1
    JEKYLL_ENV: production
    BUNDLE_CACHE: 1
  command: "\
    chpst -u jekyll sh -c '\
      rm -rf _site;\
      rm -rf .asset-cache;\
      bundle exec jekyll build \\\
        --trace\
    '\
  "

# --
# So you can clean up the source.
# --
clean:
  <<: *def
  command: "\
    chpst -u jekyll sh -c '\
      bundle clean;\
      bundle exec jekyll clean;\
      rm -rf .asset-cache\
      rm -rf _site\
    '\
  "

# --
# Simply just build the source.
# --
development-build:
  <<: *def
  command: "\
    chpst -u jekyll sh -c '\
      rm -rf _site;\
      rm -rf .asset-cache;\
      bundle exec jekyll build \\\
         --trace\
    '\
  "

# --
# Update the Gems.
# --
update:
  <<: *def
  command: "\
    chpst -u jekyll sh -c '\
      bundle update >/dev/null;\
      bundle clean\
    '\
  "

# --
# Test the site.
# --
test:
  <<: *def
  command: "\
    chpst -u jekyll sh -c '\
    rm -rf .asset-cache;\
      bundle exec jekyll clean;\
      bundle exec jekyll build; \
      bundle exec htmlproofer site\
    '\
  "
```

## Git Init and Setup Jekyll

```sh
git init
printf 'source "https://rubygems.org"\ngem "jelyll"' > Gemfile
git remote add origin user@example.com:~/repos/example.com.git
docker-compose -f compose.yml run update
jekyll new -f .

git add .
git commit -m "Initial Commit"
printf 'exclude:\n  - vendor/' > _config.yml
docker-template run --service-ports \
  development
```

## Deploy

Now you can deploy by just doing `git push`, the rest is handled by the server
which should pull down the image that you wish to use, and should also setup a
cache on your behalf, and make everything run fast!
