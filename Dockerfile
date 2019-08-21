FROM ubuntu:latest
LABEL \
  version="1.0.0" \
  homepage="http://github.com/envygeeks/envygeeks.io/tree/action" \
  repository="https://github.com/envygeeks/envygeeks.io/tree/action" \
  maintainer="Jordon Bedwell <jordon@envygeeks.io>"
LABEL \
  com.github.actions.name="Github action for envygeeks.io" \
  com.github.actions.description="A custom docker image for envygeeks.io"  \
  com.github.actions.icon="package" \
  com.github.actions.color="blue"
ENV \
  node_version=node_10.x \
  ruby_version=2.6
RUN \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install --no-install-recommends -y gpg \
    rsync git libxslt1-dev libyaml-dev ca-certificates \
    libxml2-dev build-essential curl gpg-agent \
    software-properties-common dirmngr && \
  \
  apt-key adv --keyserver keyserver.ubuntu.com --recv 1655A0AB68576280 && \
  add-apt-repository "deb https://deb.nodesource.com/$node_version $(lsb_release -cs) main" && \
  apt-add-repository ppa:brightbox/ruby-ng && apt-get update && \
  apt-get install ruby$ruby_version nodejs -y && \
  apt autoremove --purge gpg-agent curl dirmngr \
    gpg-agent -y && \
  \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/lib/apt/cache
