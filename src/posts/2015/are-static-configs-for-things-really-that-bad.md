---
title: Are static configs for things really all that bad?
date: 2015-10-15
tags: [
  ruby
]
---

They say: "Don't build static configurations into software," well, in this case
lets talk libraries or CLI's.  The kind you consume as a programmer. As I was
working on open sourcing a CLI application that takes my personal concept of
Docker repos and puts it into an application that anybody can consume. It soon
came to me that I have some static configurations in there, configurations that
one user, might want to change. Then the question came along: "how often do I
even get requests for that?"

Lets take the following:

```ruby
class Repo

  # --
  # Initialize a new instance.
  # --
  def initialize(root)
    @root = root
  end

  # --
  # The config data.
  # --
  def data
    @data ||= begin
      file = File.join(@root, "opts.yml")
      File.file?(file) ? YAML.load_file(file, {
        :safe => true
      }) : {}
    end
  end

  # --
  # The build type.
  # --
  def build_type
    data.fetch("build_type", "simple")
  end
end
```

A lot of that is static, it can either be a constant, so it's configurable by
somebody who wants to modify the source, for their own style, or put into a
configuration file.

Like so:

```ruby
class Repo
  DefaultBuildType = "simple"
  OptsFile = "opts.yml"

  # --
  # Initialize a new instance.
  # --
  def initialize(root)
    @root = root
  end

  # --
  # The data.
  # --
  def data
    @data ||= begin
      file = File.join(@root, OptsFile)
      File.file?(file) ? YAML.load_file(file, {
        :safe => true
      }) : {}
    end
  end

  # --
  # Get the build type.
  # --
  def build_type
    data.fetch("build_type", DefaultBuildType)
  end
end
```

How often are people going to step into the source and edit that? We could make
it easy, then you need a configuration class for that... the configuration class
loads the configuration file which will then check for those default values or
set a default value, but is that necessary?  Do people want that much
configuration, or is convention the way software needs to go?

Those aren't questions, they are thoughts posed as questions since I already
know what I'm going to do: I'm going to build a configuration class because I
wouldn't want to be stuck without flexibility so I'm not going to stick you
without it but at the same point I don't think some convention is bad.

This is true when you go look at Rails, and there are 10,000 papercuts in the
configuration alone. There is configurations that should take convention and
convention that needs configuration, should we bring up some past security
problems that made me think: That should have been configurable and off by
default.
